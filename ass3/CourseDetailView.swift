//
//  CourseDetailView.swift
//  ass3
//
//  Created by user941049 on 5/15/25.
//

import SwiftUI

struct CourseDetailView: View {
    var course: Course
    @StateObject var vm = CourseVM()
    @AppStorage("userPhone") var userPhone: String = ""
    @Environment(\.dismiss) var dismiss

    @State private var showSuccess = false
    @State private var successMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text(course.name)
                .font(.largeTitle).bold()

            Text(course.time)
                .font(.title3)
                .foregroundColor(.gray)

            Text("Remaining spots: \(course.left)")
                .font(.headline)

            if userPhone.isEmpty {
                Text("Please log in to book this class.")
                    .foregroundColor(.red)
            } else if vm.has(course, userId: userPhone) {
                Button("Cancel Booking") {
                    vm.cancel(course, userId: userPhone) {
                        successMessage = "Booking cancelled."
                        showSuccess = true
                    }
                }
                .foregroundColor(.red)
            } else {
                Button("Book") {
                    vm.book(course, userId: userPhone) {
                        successMessage = "Booking successful!"
                        showSuccess = true
                    }
                }
                .disabled(course.left == 0)
                .foregroundColor(.white)
                .padding()
                .background(course.left == 0 ? Color.gray : Color.blue)
                .cornerRadius(8)
            }

            Button("Back") {
                dismiss()
            }
            .padding(.top, 10)
        }
        .padding()
        .alert(isPresented: $showSuccess) {
            Alert(
                title: Text("Success"),
                message: Text(successMessage),
                dismissButton: .default(Text("OK")) {
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    CourseDetailView(
        course: Course(id: "0", name: "Demo", time: "Mon 10am", left: 5, users: [])
    )
}
