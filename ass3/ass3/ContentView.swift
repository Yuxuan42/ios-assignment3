//
//  ContentView.swift
//  ass3
//
//  Created by user941049 on 5/14/25.
//

import SwiftUI

struct ContentView: View {
@State var name = ""
@State var logged = false

var body: some View {
if logged {
    CourseListView(logged: $logged)
} else {
    VStack(spacing: 20){
        Text("FitBook")
            .font(.largeTitle)

        TextField("Your name", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)

        Button("Login") {
            if name != "" {
                UserDefaults.standard.set(name, forKey: "user")
                logged = true
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    .onAppear {
        UserDefaults.standard.removeObject(forKey: "user")
        if let n = UserDefaults.standard.string(forKey: "user") {
            name = n
            logged = true
        }
    }
}
}
}

#Preview {
ContentView()
}


