//
//  ProfileView.swift
//
//  Created by Anna Huang on 14/5/2025.
//

import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @AppStorage("userPhone") var userPhone: String = ""
    @AppStorage("userName") var userName: String = ""
    @State private var phone = ""
    @State private var passcode = ""
    @State private var error = ""
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            if !userPhone.isEmpty {
                Text("Hello, \(userName)!")
                    .font(.title)
                Text("Phone: \(userPhone)")
                Button("Log Out") {
                    userPhone = ""
                    userName = ""
                }
                .foregroundColor(.red)
            } else {
                Text("Login to FitBook")
                    .font(.headline)
                TextField("Phone Number", text: $phone)
                    .keyboardType(.phonePad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Passcode", text: $passcode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if !error.isEmpty {
                    Text(error).foregroundColor(.red)
                }
                Button(action: {
                    error = ""
                    isLoading = true
                    login(phone: phone, passcode: passcode)
                }) {
                    HStack {
                        Spacer()
                        Text(isLoading ? "Logging in..." : "Login")
                        Spacer()
                    }
                }
                .disabled(isLoading)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
        .padding()
    }

    // Simple Firestore login
    func login(phone: String, passcode: String) {
        let db = Firestore.firestore()
        db.collection("members").whereField("phone", isEqualTo: phone)
            .whereField("passcode", isEqualTo: passcode)
            .getDocuments { snapshot, err in
                isLoading = false
                if let err = err {
                    error = "Error: \(err.localizedDescription)"
                    return
                }
                guard let doc = snapshot?.documents.first,
                      let member = try? doc.data(as: Member.self) else {
                    error = "Incorrect phone or passcode."
                    return
                }
                userPhone = member.phone
                userName = member.name
            }
    }
}

#Preview {
    ProfileView()
}
