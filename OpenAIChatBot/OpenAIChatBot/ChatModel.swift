//
//  ChatModel.swift
//  ChatGPTApp
//
//  Created by Raju Chinnam on 2/13/25.
//

import Foundation

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessages]
}

struct OpenAIChatMessages: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct Message: Codable {
    let id: UUID
    let role: SenderRole
    let content: String
    let CreateAt: Date
}

struct OpenAIChatResponse: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let system_fingerprint: String
    let choices: [OpenAIChoices]
    let service_tier: String
    let usage: Usage
}

struct OpenAIChoices: Decodable {
    let index: Int
    let message: OpenAIChatMessages
    let logprobs: [Double]?
    let finish_reason: String
}

struct Usage: Decodable {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
    let completion_tokens_details: CompletionTokensDetails
}

struct CompletionTokensDetails: Decodable {
    let reasoning_tokens: Int
    let accepted_prediction_tokens: Int
    let rejected_prediction_tokens: Int
}
