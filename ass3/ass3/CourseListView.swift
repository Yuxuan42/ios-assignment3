//
//  CourseListView.swift
//  ass3
//
//  Created by user941049 on 5/14/25.
//

import SwiftUI

struct Course: Codable, Identifiable {
    var id: Int
    var name: String
    var time: String
    var left: Int
    var users: [String]
}

class CourseVM: ObservableObject {
    @Published var list: [Course] = []
    let ukey = "user"
    let ckey = "course_data"

    init() {
        if let d = UserDefaults.standard.data(forKey: ckey),
           let decoded = try? JSONDecoder().decode([Course].self, from: d) {
            list = decoded
        } else {
            list = [
                Course(id: 1, name: "Yoga", time: "Mon 8am", left: 10, users: []),
                Course(id: 2, name: "HIIT", time: "Wed 6:30pm", left: 8, users: []),
                Course(id: 3, name: "Stretch", time: "Fri 7pm", left: 12, users: []),
                Course(id: 4, name: "Zumba", time: "Sun 5pm", left: 15, users: [])
            ]
            save()
        }
    }

    func getUser() -> String {
        UserDefaults.standard.string(forKey: ukey) ?? ""
    }

    func save() {
        if let d = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(d, forKey: ckey)
        }
    }

    func has(_ c: Course) -> Bool {
        c.users.contains(getUser())
    }

    func book(_ c: Course) {
        if let i = list.firstIndex(where: { $0.id == c.id }),
           !has(list[i]), list[i].left > 0 {
            list[i].users.append(getUser())
            list[i].left -= 1
            save()
        }
    }

    func cancel(_ c: Course) {
        if let i = list.firstIndex(where: { $0.id == c.id }),
           let u = list[i].users.firstIndex(of: getUser()) {
            list[i].users.remove(at: u)
            list[i].left += 1
            save()
        }
    }
}

struct CourseListView: View {
    @Binding var logged: Bool
    @State var showBookings = false
    @StateObject var vm = CourseVM()

    var body: some View {
        if showBookings {
            MyBookingsView(logged: $logged)
        } else {
            VStack {
                Text("Available Classes")
                    .font(.title)
                    .bold()
                    .padding(.top)

                List {
                    ForEach(vm.list) { c in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(c.name).font(.headline)
                            Text(c.time).foregroundColor(.gray)
                            Text("Left: \(c.left)")

                            if vm.has(c) {
                                Button("Cancel") {
                                    vm.cancel(c)
                                }.foregroundColor(.red)
                            } else {
                                Button("Book") {
                                    vm.book(c)
                                }
                                .disabled(c.left == 0)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(c.left == 0 ? Color.gray : Color.blue)
                                .cornerRadius(6)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }

                HStack {
                    Button("My Bookings") {
                        showBookings = true
                    }
                    .padding(10)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(6)

                    Button("Back") {
                        logged = false
                    }
                    .padding(10)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                }
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    CourseListView(logged: .constant(true))
}





