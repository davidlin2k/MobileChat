//
//  ContentView.swift
//  MobileChat
//
//  Created by David Lin on 2023-02-13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ChatView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
