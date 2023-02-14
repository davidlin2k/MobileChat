//
//  ChatView.swift
//  MobileChat
//
//  Created by David Lin on 2023-02-13.
//

import SwiftUI

struct ChatView: View {
    @State private var typedMessage: String = ""
    @ObservedObject private var chat = Chat(messages: [])

    let user = User(name: "David", avatar: "", isCurrentUser: true)
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { value in
                    VStack(alignment: .leading) {
                        ForEach(chat.messages) { message in
                            MessageView(currentMessage: message)
                                .padding(.bottom)
                                .id(message.id)
                        }
                    }
                    .onChange(of: chat.messages.last?.id) { id in
                        value.scrollTo(id)
                    }
                }
            }
            
            HStack {
                TextField("Message", text: $typedMessage)
                Button("Send") {
                    sendMessage()
                }
            }
            .frame(minHeight: 50)
        }.padding()
    }
    
    func sendMessage() {
        self.chat.sendMessage(Message(content: typedMessage, user: user))
        self.typedMessage = ""
    }
}
