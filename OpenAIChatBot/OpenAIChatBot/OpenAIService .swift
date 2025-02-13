//
//  OpenAIService .swift
//  ChatGPTApp
//
//  Created by Raju Chinnam on 2/13/25.
//

import Foundation

class OpenAIService {
    
    private let endPointUrl = URL(string: "https://api.openai.com/v1/chat/completions")
    private let openApiKey: String = " Your API Key"
    
    func sendMessage(messages: [Message]) async -> OpenAIChatResponse? {
        let openAIMessages = messages.map({OpenAIChatMessages(role: $0.role, content: $0.content)})
        let requestBody = OpenAIChatBody(model: "gpt-40", messages: openAIMessages)
        
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            print("Failed to encode request body")
            return nil
        }
        var request = URLRequest(url: endPointUrl!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(openApiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("HTTP Error: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                return nil
            }
            let decodedResponse = try JSONDecoder().decode(OpenAIChatResponse.self, from: data)
            return decodedResponse
        } catch {
            print("Error fetching OpenAI response: \(error)")
            return nil
        }
    }
}


