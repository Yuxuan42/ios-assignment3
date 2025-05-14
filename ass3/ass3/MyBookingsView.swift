//
//  MyBookingsView.swift
//  ass3
//
//  Created by user941049 on 5/15/25.
//

import SwiftUI

struct MyBookingsView: View {
    @Binding var logged: Bool
    @StateObject var vm = CourseVM()

    var body: some View {
        VStack {
            Text("My Bookings")
                .font(.title)
                .bold()
                .padding(.top)

            List {
                ForEach(vm.list.filter { vm.has($0) }) { c in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(c.name).font(.headline)
                        Text(c.time).foregroundColor(.gray)

                        Button("Cancel") {
                            vm.cancel(c)
                        }
                        .foregroundColor(.red)
                    }
                    .padding(.vertical, 6)
                }
            }

            Button("Back") {
                logged = true // 或者回课程页（你想怎么跳我来配）
            }
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    MyBookingsView(logged: .constant(true))
}
