//
//  CourseListView.swift
//  ass3
//
//  Created by user941049 on 5/14/25.
//

//
//  CourseListView.swift
//  ass3
//
//  Created by user941049 on 5/14/25.
//

import SwiftUI

struct CourseListView: View {
    @StateObject var vm = CourseVM()
    @State private var selectedCourse: Course?
    @State private var showDetail = false

    var body: some View {
        NavigationView {
            List(vm.courses) { course in
                Button {
                    selectedCourse = course
                    showDetail = true
                } label: {
                    VStack(alignment: .leading) {
                        Text(course.name)
                            .font(.headline)
                        Text(course.time)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Spots left: \(course.left)")
                            .font(.caption)
                            .foregroundColor(course.left > 0 ? .teal : .red)
                    }
                }
                .disabled(course.left == 0)
            }
            .navigationTitle("Classes")
            .sheet(isPresented: $showDetail) {
                if let course = selectedCourse {
                    CourseDetailView(course: course)
                }
            }
        }
    }
}
