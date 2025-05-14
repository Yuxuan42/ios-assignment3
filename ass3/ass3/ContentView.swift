//
//  ContentView.swift
//  ass3
//
//  Created by user941049 on 5/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        if isLoggedIn {
            CourseListView()
        } else {
            VStack(spacing: 20) {
                Text("Welcome to FitBook")
                    .font(.largeTitle)
                    .bold()

                TextField("Enter your name", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Login") {
                    if !username.trimmingCharacters(in: .whitespaces).isEmpty {
                        UserDefaults.standard.set(username, forKey: "currentUser")
                        isLoggedIn = true
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .onAppear {
                if let savedUser = UserDefaults.standard.string(forKey: "currentUser") {
                    username = savedUser
                    isLoggedIn = true
                }
            }
        }
    }
}

