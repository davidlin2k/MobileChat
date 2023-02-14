//
//  MessageView.swift
//  MobileChat
//
//  Created by David Lin on 2023-02-13.
//

import SwiftUI

struct MessageView: View {
    @ObservedObject var currentMessage: Message
    
    var body: some View {
        HStack(alignment: .top) {
            if !currentMessage.user.isCurrentUser {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            }
            else {
                Spacer()
            }
            
            
            MessageContentView(contentMessage: currentMessage.content, isCurrentUser: currentMessage.user.isCurrentUser)
            
            if currentMessage.user.isCurrentUser {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            }
        }
        .background(.clear)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(currentMessage: Message(content: "There are a lot of premium iOS templates on iosapptemplates.com", user: User(name: "David", avatar: "", isCurrentUser: false)))
    }
}
