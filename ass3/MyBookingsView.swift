//
//  MyBookingsView.swift
//  ass3
//
//  Created by user941049 on 5/15/25.
//

import SwiftUI

struct MyBookingsView: View {
    @StateObject var vm = CourseVM()
    @AppStorage("userPhone") var userPhone: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("My Bookings")
                    .font(.title).bold()
                    .padding(.top)

                List {
                    ForEach(vm.courses.filter { vm.has($0, userId: userPhone) }) { c in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(c.name).font(.headline)
                            Text(c.time).foregroundColor(.gray)
                            Text("Booked")
                            Button("Cancel") {
                                vm.cancel(c, userId: userPhone)
                            }
                            .foregroundColor(.red)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
    }
}

#Preview {
    MyBookingsView()
}
