//
//  Member.swift
//
//  Created by Anna Huang on 14/5/2025.
//

import Foundation
import FirebaseFirestore

struct Member: Identifiable, Codable {
    @DocumentID var id: String?
    var phone: String
    var passcode: String
    var name: String
}
