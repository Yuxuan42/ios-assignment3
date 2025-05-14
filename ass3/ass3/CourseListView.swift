//
//  CourseListView.swift
//  ass3
//
//  Created by user941049 on 5/14/25.
//

import SwiftUI

// 数据模型：课程
struct Course: Codable, Identifiable {
    let id: Int
    let name: String
    let time: String
    var capacity: Int
    var enrolledUsers: [String]
}

// 课程管理 ViewModel
class CourseViewModel: ObservableObject {
    @Published var courses: [Course] = []
    private let userKey = "currentUser"
    private let courseKey = "courses"

    init() {
        loadCourses()
    }

    func loadCourses() {
        if let data = UserDefaults.standard.data(forKey: courseKey),
           let decoded = try? JSONDecoder().decode([Course].self, from: data) {
            self.courses = decoded
        } else {
            // 如果没有数据，初始化默认课程
            self.courses = [
                Course(id: 1, name: "Morning Yoga", time: "Mon 8:00 AM", capacity: 10, enrolledUsers: []),
                Course(id: 2, name: "HIIT Blast", time: "Wed 6:30 PM", capacity: 8, enrolledUsers: []),
                Course(id: 3, name: "Evening Stretch", time: "Fri 7:00 PM", capacity: 12, enrolledUsers: [])
            ]
            saveCourses()
        }
    }

    func saveCourses() {
        if let encoded = try? JSONEncoder().encode(courses) {
            UserDefaults.standard.set(encoded, forKey: courseKey)
        }
    }

    func currentUser() -> String {
        UserDefaults.standard.string(forKey: userKey) ?? "Guest"
    }

    func hasBooked(_ course: Course) -> Bool {
        course.enrolledUsers.contains(currentUser())
    }

    func book(_ course: Course) {
        guard let index = courses.firstIndex(where: { $0.id == course.id }),
              !hasBooked(courses[index]),
              courses[index].capacity > 0 else { return }

        courses[index].enrolledUsers.append(currentUser())
        courses[index].capacity -= 1
        saveCourses()
    }
}

// 页面视图
struct CourseListView: View {
    @StateObject private var viewModel = CourseViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.courses) { course in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(course.name)
                            .font(.headline)
                        Text(course.time)
                            .foregroundColor(.secondary)
                        Text("Remaining spots: \(course.capacity)")

                        if viewModel.hasBooked(course) {
                            Text("✅ You have booked this class")
                                .foregroundColor(.green)
                                .font(.subheadline)
                        } else {
                            Button("Book") {
                                viewModel.book(course)
                            }
                            .disabled(course.capacity == 0)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(course.capacity == 0 ? Color.gray : Color.blue)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Available Classes")
        }
    }
}

#Preview {
    CourseListView()
}

