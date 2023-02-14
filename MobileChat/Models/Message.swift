//
//  Message.swift
//  MobileChat
//
//  Created by David Lin on 2023-02-13.
//

import Foundation

class Message: Identifiable, ObservableObject {
    var id: UUID
    
    @Published var content: String
    var user: User
    
    init(id: UUID = UUID(), content: String, user: User) {
        self.id = id
        self.content = content
        self.user = user
    }
    
    func updateContent(content: String) {
        self.content = content
    }
}
