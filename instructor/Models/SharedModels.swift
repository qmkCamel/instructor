//
//  SharedModels.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//
//  共享数据模型 - 主应用和 Widget 共用
//

import Foundation
import SwiftUI

// MARK: - 处境类型（共享）
enum SharedSituation: String, CaseIterable, Codable {
    case hesitating = "我在犹豫"
    case retreating = "我在退缩"
    case struggling = "我在硬撑"
    case passive = "我在被动挨打"
    
    var shortName: String {
        switch self {
        case .hesitating: return "犹豫"
        case .retreating: return "退缩"
        case .struggling: return "硬撑"
        case .passive: return "被动"
        }
    }
}

// MARK: - 行动选择（共享）
enum SharedActionChoice: String, CaseIterable, Codable {
    case did = "我照做了"
    case didNot = "我没照做"
    case avoided = "我逃避了"
    
    var shortName: String {
        switch self {
        case .did: return "照做了"
        case .didNot: return "没照做"
        case .avoided: return "逃避了"
        }
    }
    
    var color: Color {
        switch self {
        case .did: return .green
        case .didNot: return .orange
        case .avoided: return .red
        }
    }
}

// MARK: - 语录（共享）
struct SharedQuote: Codable {
    let content: String
    let source: String
}

// MARK: - 最近记录（共享）
struct SharedLastRecord: Codable {
    let quote: SharedQuote
    let situation: SharedSituation
    let action: SharedActionChoice
    let timestamp: Date
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter.string(from: timestamp)
    }
}

// MARK: - 共享数据管理器
final class SharedDataManager {
    static let shared = SharedDataManager()
    
    private let userDefaults: UserDefaults
    private let lastRecordKey = "lastQuoteRecord"
    
    init() {
        // 使用 App Group 共享数据
        if let defaults = UserDefaults(suiteName: "group.com.edge.instructor") {
            self.userDefaults = defaults
        } else {
            self.userDefaults = .standard
        }
    }
    
    // 保存最近一条记录（供 Widget 显示）
    func saveLastRecord(_ record: SharedLastRecord) {
        if let data = try? JSONEncoder().encode(record) {
            userDefaults.set(data, forKey: lastRecordKey)
        }
    }
    
    // 获取最近一条记录
    func getLastRecord() -> SharedLastRecord? {
        guard let data = userDefaults.data(forKey: lastRecordKey),
              let record = try? JSONDecoder().decode(SharedLastRecord.self, from: data) else {
            return nil
        }
        return record
    }
    
    // 清除记录
    func clearLastRecord() {
        userDefaults.removeObject(forKey: lastRecordKey)
    }
}

