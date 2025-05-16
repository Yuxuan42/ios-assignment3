//
//  CourseVM.swift
//
//  Created by Anna Huang on 14/5/2025.
//

import Foundation
import Firebase
import FirebaseFirestore

class CourseVM: ObservableObject {
    @Published var courses: [Course] = []

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init() {
        fetchCourses()
    }

    deinit {
        listener?.remove()
    }

    func fetchCourses() {
        listener = db.collection("classes").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            self.courses = documents.compactMap { try? $0.data(as: Course.self) }
        }
    }

    func has(_ course: Course, userId: String) -> Bool {
        course.users.contains(userId)
    }

    func book(_ course: Course, userId: String, completion: (() -> Void)? = nil) {
        guard let id = course.id, !userId.isEmpty else { return }
        let docRef = db.collection("classes").document(id)
        docRef.updateData([
            "users": FieldValue.arrayUnion([userId]),
            "left": max(course.left - 1, 0)
        ]) { error in
            if let error = error {
                print("Error booking: \(error.localizedDescription)")
            }
            completion?()
        }
    }

    func cancel(_ course: Course, userId: String, completion: (() -> Void)? = nil) {
        guard let id = course.id, !userId.isEmpty else { return }
        let docRef = db.collection("classes").document(id)
        docRef.updateData([
            "users": FieldValue.arrayRemove([userId]),
            "left": course.left + 1
        ]) { error in
            if let error = error {
                print("Error cancelling: \(error.localizedDescription)")
            }
            completion?()
        }
    }
}
