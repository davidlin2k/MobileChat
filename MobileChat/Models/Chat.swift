//
//  Chat.swift
//  MobileChat
//
//  Created by David Lin on 2023-02-13.
//

import Foundation
import Combine

@MainActor
class Chat: ObservableObject {
    let GPTService = RealGPT3Service()
    
    @Published var messages: [Message]
    private var subscription: AnyCancellable?
    
    init(messages: [Message]) {
        self.messages = messages
        
        self.messages = MessageDataStore.shared.getAllMessages()
    }
    
    func sendMessage(_ chatMessage: Message) {
        MessageDataStore.shared.insert(message: chatMessage)
        messages.append(chatMessage)
        
        let responseMessage = Message(content: "", user: User(name: "GPT-3", avatar: ""))
        
        subscription = GPTService.generate(prompt: "Q: \(chatMessage.content) A:")
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.subscription?.cancel()
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    responseMessage.content = error.localizedDescription
                }
            }, receiveValue: { generatedText in
                responseMessage.updateContent(content: generatedText.trimmingCharacters(in: .whitespacesAndNewlines))
                MessageDataStore.shared.insert(message: responseMessage)
            })
        
        messages.append(responseMessage)
    }
}
