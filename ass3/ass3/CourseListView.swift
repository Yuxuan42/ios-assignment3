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
    var users: [String]  // booked users
}

class CourseVM: ObservableObject {
    @Published var list: [Course] = []
    let ukey = "user"
    let ckey = "course_data"

    init() {
        if let d = UserDefaults.standard.data(forKey: ckey),
           let got = try? JSONDecoder().decode([Course].self, from: d) {
            list = got
        } else {
            list = [
                Course(id: 1, name: "Yoga", time: "Mon 8am", left: 10, users: []),
                Course(id: 2, name: "HIIT", time: "Wed 6:30pm", left: 8, users: []),
                Course(id: 3, name: "Stretch", time: "Fri 7pm", left: 12, users: []),
                Course(id: 4, name: "Zumba", time: "Sun 5pm", left: 15, users: [])
            ]
            save()  // 首次存
        }
    }

    func who() -> String {
        UserDefaults.standard.string(forKey: ukey) ?? ""
    }

    func save() {
        if let d = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(d, forKey: ckey)
        }
    }

    func has(_ c: Course) -> Bool {
        c.users.contains(who())  // who
    }

    func book(_ c: Course) {
        if let i = list.firstIndex(where: { $0.id == c.id }) {
            if !has(list[i]) && list[i].left > 0 {
                list[i].users.append(who())
                list[i].left -= 1
                save()
            }
        }
    }

    func cancel(_ c: Course) {
        if let i = list.firstIndex(where: { $0.id == c.id }),
           let j = list[i].users.firstIndex(of: who()) {
            list[i].users.remove(at: j)
            list[i].left += 1
            save()
        }
    }
}

struct CourseListView: View {
    @Binding var logged: Bool
    @State var showB = false
    @StateObject var vm = CourseVM()
    @State var detail: Course? = nil

    var body: some View {
        if showB {
            MyBookingsView(logged: $logged)  // 看bookinglist
        } else if let d = detail {

            CourseDetailView(course: d, goBack: Binding(get: { false }, set: { _ in detail = nil }))
        } else {
            VStack {
                Text("Courses")
                    .font(.title).bold().padding(.top)

                List {
                    ForEach(vm.list) { c in
                        Button {
                            detail = c  // go detail
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(c.name).font(.headline)
                                Text(c.time).foregroundColor(.gray)
                                Text("Left: \(c.left)")

                                if vm.has(c) {
                                    Button("Cancel") {
                                        vm.cancel(c)
                                    }
                                    .foregroundColor(.red)
                                } else {
                                    Button("Book") {
                                        vm.book(c)
                                    }
                                    .disabled(c.left == 0)
                                    .padding(.horizontal,10)
                                    .padding(.vertical,5)
                                    .background(c.left == 0 ? Color.gray : Color.blue)
                                    .cornerRadius(6)
                                    .foregroundStyle(.white)
                                }
                            }.padding(.vertical,6)
                        }
                        .buttonStyle(PlainButtonStyle())  
                    }
                }

                HStack {
                    Button("My Bookings") {
                        showB = true
                    }
                    .padding(8)
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .cornerRadius(6)

                    Button("Back") {
                        logged = false  // 回到登录页
                    }
                    .padding(8)
                    .background(Color.gray)
                    .foregroundStyle(.white)
                    .cornerRadius(6)
                }
                .padding(.bottom, 10)
            }
        }
    }
}






