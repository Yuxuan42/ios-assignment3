//
//  Course.swift
//
//  Created by Anna Huang on 14/5/2025.
//

import Foundation
import FirebaseFirestore

struct Course: Identifiable, Codable {
    @DocumentID var id: String? // Firestore uses String IDs
    var name: String
    var time: String
    var left: Int
    var users: [String] // Array of user names or user IDs
}
