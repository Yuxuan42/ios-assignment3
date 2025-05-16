//
//  ContentView.swift
//  ass3
//
//  Created by user941049 on 5/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CourseListView()
                .tabItem {
                    Label("Classes", systemImage: "list.bullet")
                }
            MyBookingsView()
                .tabItem {
                    Label("My Bookings", systemImage: "bookmark.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
