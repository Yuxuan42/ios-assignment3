//
//  MyBookingsView.swift
//  ass3
//
//  Created by user941049 on 5/15/25.
//

import SwiftUI

struct MyBookingsView: View {
    @Binding var logged: Bool
    @StateObject var vm = CourseVM()  // viewmodel 持久化数据
    @State var back = false  // 控制返回课程页

    var body: some View {
        if back {
            CourseListView(logged: $logged)  // 返回课程页
        } else {
            VStack {
                Text("My Bookings")
                    .font(.title).bold()
                    .padding(.top)

                List {
                    ForEach(vm.list.filter { vm.has($0) }) { c in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(c.name).font(.headline)
                            Text(c.time).foregroundColor(.gray)
                            Text("Booked")
                            Button("Cancel") {
                                vm.cancel(c)
                            }
                            .foregroundColor(.red)
                        }
                        .padding(.vertical, 6)
                    }
                }

                Button("Back") {
                    back = true
                }
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    MyBookingsView(logged: .constant(true))
}


