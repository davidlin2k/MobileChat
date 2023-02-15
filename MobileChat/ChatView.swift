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

    @FocusState private var typedMessageFocused: Bool
    
    let user = User(name: "David", avatar: "", isCurrentUser: true)
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ScrollViewReader { value in
                    VStack(alignment: .leading) {
                        ForEach(chat.messages) { message in
                            MessageView(currentMessage: message)
                                .padding(.bottom)
                                .id(message.id)
                        }
                    }
                    .onChange(of: chat.messages.last?.id) { id in
                        withAnimation {
                            value.scrollTo(id)
                        }
                    }
                    .onAppear {
                        withAnimation {
                            value.scrollTo(chat.messages.last?.id)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                }
            }
            
            HStack {
                TextField("Message", text: $typedMessage)
                    .focused($typedMessageFocused)
                
                
                Button("Send") {
                    sendMessage()
                }
            }
            .frame(minHeight: 50)
            .padding(.horizontal)
        }.toolbar {
            Spacer()
            Button("Clear") {
                MessageDataStore.shared.deleteTable()
                chat.messages.removeAll()
            }
        }
    }
    
    func sendMessage() {
        typedMessageFocused = false
        
        self.chat.sendMessage(Message(content: typedMessage, user: user))
        self.typedMessage = ""
    }
}
