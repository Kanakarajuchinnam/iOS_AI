//
//  ContentView.swift
//  ChatGPTApp
//
//  Created by Raju Chinnam on 2/13/25.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewModel.messages.filter { $0.role != .system }, id: \.id) { message in
                            MessageView(message: message)
                                .id(message.id) 
                        }
                    }
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        if let lastMessage = viewModel.messages.last {
                            scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack {
                TextField("Enter a message...", text: $viewModel.currentInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 8)
                    .onSubmit {
                        viewModel.sendMessage()
                    }
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Text("Ask Me")
                        .bold()
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(viewModel.currentInput.isEmpty ? Color.gray.opacity(0.5) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(viewModel.currentInput.isEmpty)
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

struct MessageView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.role == .user { Spacer() }
            
            Text(message.content)
                .padding()
                .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.role == .user ? .white : .black)
                .cornerRadius(8)
                .frame(maxWidth: 250, alignment: message.role == .user ? .trailing : .leading)
            
            if message.role == .assistant { Spacer() }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ChatView()
}
