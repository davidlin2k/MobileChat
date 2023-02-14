//
//  MessageContentView.swift
//  MobileChat
//
//  Created by David Lin on 2023-02-13.
//

import SwiftUI

struct MessageContentView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
        ZStack {
            Text(self.contentMessage)
                .textSelection(.enabled)
            
            if !isCurrentUser && contentMessage.isEmpty {
                ProgressView()
                    .frame(width: 30, height: 30)
            }
        }
        .padding(10)
        .foregroundColor(.white)
        .background(isCurrentUser ? Color.blue: Color.gray)
        .cornerRadius(10)
    }
}

struct MessageContentViewPreview: PreviewProvider {
    static var previews: some View {
        MessageContentView(contentMessage: "Hello", isCurrentUser: false)
    }
}

