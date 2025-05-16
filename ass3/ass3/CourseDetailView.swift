//
//  CourseDetailView.swift
//  ass3
//
//  Created by user941049 on 5/15/25.
//

import SwiftUI

struct CourseDetailView: View {
    var course: Course
    @Binding var goBack: Bool
    @StateObject var vm = CourseVM()

    var body: some View {
        VStack(spacing: 20) {
            Text(course.name)
                .font(.largeTitle).bold()

            Text(course.time)
                .font(.title3)
                .foregroundColor(.gray)

            Text("Remaining spots: \(course.left)")
                .font(.headline)

            if vm.has(course) {
                Button("Cancel Booking") {
                    vm.cancel(course)
                    goBack = true
                }
                .foregroundColor(.red)
            } else {
                Button("Book") {
                    vm.book(course)
                }
                .disabled(course.left == 0)
                .foregroundColor(.white)
                .padding()
                .background(course.left == 0 ? Color.gray : Color.blue)
                .cornerRadius(8)
            }

            Button("Back") {
                goBack = true
            }
            .padding(.top, 10)
        }
        .padding()
    }
}

#Preview {
    CourseDetailView(course: Course(id: 0, name: "Demo", time: "Mon 10am", left: 5, users: []), goBack: .constant(false))
}


