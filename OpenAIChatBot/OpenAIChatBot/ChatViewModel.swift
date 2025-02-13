//
//  ChatViewMOdel.swift
//  ChatGPTApp
//
//  Created by Raju Chinnam on 2/13/25.
//

import Foundation
extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = []
        @Published var currentInput: String = ""
        
        private let openAIService = OpenAIService()
        
        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, CreateAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            Task {
                let response = await openAIService.sendMessage(messages: messages)
                guard let recievedOpenAIMessage = response?.choices.first?.message else {
                    print("Sorry No Message")
                    return
                }
                
                let recievedMessage = Message(id: UUID(), role: recievedOpenAIMessage.role, content: recievedOpenAIMessage.content, CreateAt: Date())
                await MainActor.run {
                    messages.append(recievedMessage)
                }
            }
        }
    }
}
