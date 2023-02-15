//
//  MessageDataStore.swift
//  MobileChat
//
//  Created by David Lin on 2023-02-14.
//

import SQLite
import Foundation

class MessageDataStore {

    static let DIR_TASK_DB = "MessageDB"
    static let STORE_NAME = "message.sqlite3"

    private let messages = Table("Messages")

    private let id = Expression<Int64>("id")
    private let content = Expression<String>("content")
    private let user = Expression<Bool>("user")

    static let shared = MessageDataStore()

    private var db: Connection? = nil

    private init() {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_TASK_DB)

            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent(Self.STORE_NAME).path
                db = try Connection(dbPath)
                createTable()
                print("SQLiteDataStore init successfully at: \(dbPath) ")
            } catch {
                db = nil
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
            db = nil
        }
    }

    private func createTable() {
        guard let database = db else {
            return
        }
        do {
            try database.run(messages.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(content)
                table.column(user)
            })
            print("Table Created...")
        } catch {
            print(error)
        }
    }
    
    func deleteTable() {
        guard let database = db else {
            return
        }
        do {
            try database.run(messages.delete())
            print("Table Deleted...")
        } catch {
            print(error)
        }
    }
    
    
    func insert(message: Message) -> Int64? {
        guard let database = db else { return nil }

        let insert = messages.insert(self.content <- message.content,
                                     self.user <- message.user.isCurrentUser)
        do {
            let rowID = try database.run(insert)
            return rowID
        } catch {
            print(error)
            return nil
        }
    }
    
    func getAllMessages() -> [Message] {
        var messages: [Message] = []
        guard let database = db else { return [] }

        do {
            for message in try database.prepare(self.messages) {
                messages.append(Message(id: UUID(), content: message[content], user: User(name: "", avatar: "", isCurrentUser: message[user])))
            }
        } catch {
            print(error)
        }
        return messages
    }
}
