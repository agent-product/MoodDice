//
//  Challenge.swift
//  MoodDice
//
//  Created by AI Assistant on 8/26/25.
//

import Foundation

// MARK: - Challenge Model
struct Challenge: Identifiable, Codable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let category: ChallengeCategory
    let isCustom: Bool
    let createdAt: Date
    
    init(title: String, description: String, category: ChallengeCategory, isCustom: Bool = false) {
        self.title = title
        self.description = description
        self.category = category
        self.isCustom = isCustom
        self.createdAt = Date()
    }
}

// MARK: - Challenge Category
enum ChallengeCategory: String, CaseIterable, Codable {
    case social = "社交"
    case selfCare = "自我关怀"
    case creativity = "创意"
    case fitness = "健身"
    case productivity = "效率"
    case mindfulness = "正念"
    case adventure = "冒险"
    case custom = "自定义"
    
    var emoji: String {
        switch self {
        case .social: return "👥"
        case .selfCare: return "💆‍♀️"
        case .creativity: return "🎨"
        case .fitness: return "💪"
        case .productivity: return "⚡"
        case .mindfulness: return "🧘"
        case .adventure: return "🌟"
        case .custom: return "✨"
        }
    }
    
    var color: String {
        switch self {
        case .social: return "blue"
        case .selfCare: return "pink"
        case .creativity: return "purple"
        case .fitness: return "green"
        case .productivity: return "orange"
        case .mindfulness: return "indigo"
        case .adventure: return "red"
        case .custom: return "gray"
        }
    }
}

// MARK: - Daily Challenge Record
struct DailyChallengeRecord: Codable {
    let date: String // YYYY-MM-DD format
    let challengeId: UUID
    let challenge: Challenge
    let isCompleted: Bool
    
    init(challenge: Challenge, isCompleted: Bool = false) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.date = formatter.string(from: Date())
        self.challengeId = challenge.id
        self.challenge = challenge
        self.isCompleted = isCompleted
    }
}
