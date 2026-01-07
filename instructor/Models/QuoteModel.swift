//
//  QuoteModel.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//

import Foundation
import SwiftUI

// MARK: - 处境类型
enum Situation: String, CaseIterable, Codable {
    case hesitating = "我在犹豫"
    case retreating = "我在退缩"
    case struggling = "我在硬撑"
    case passive = "我在被动挨打"
    
    var displayName: String {
        return self.rawValue
    }
    
    var categoryName: String {
        switch self {
        case .hesitating: return "犹豫时该看的"
        case .retreating: return "退缩时该看的"
        case .struggling: return "硬撑时该看的"
        case .passive: return "被动挨打时该看的"
        }
    }
}

// MARK: - 语录模型
struct Quote: Identifiable, Codable {
    let id: UUID
    let content: String
    let source: String
    let situation: Situation
    
    init(id: UUID = UUID(), content: String, source: String, situation: Situation) {
        self.id = id
        self.content = content
        self.source = source
        self.situation = situation
    }
}

// MARK: - 行动选择
enum ActionChoice: String, CaseIterable, Codable {
    case did = "我照做了"
    case didNot = "我没照做"
    case avoided = "我逃避了"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - 记录模型
struct QuoteRecord: Identifiable, Codable {
    let id: UUID
    let quote: Quote
    let situation: Situation
    let action: ActionChoice
    let timestamp: Date
    
    init(id: UUID = UUID(), quote: Quote, situation: Situation, action: ActionChoice, timestamp: Date = Date()) {
        self.id = id
        self.quote = quote
        self.situation = situation
        self.action = action
        self.timestamp = timestamp
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: timestamp)
    }
}

