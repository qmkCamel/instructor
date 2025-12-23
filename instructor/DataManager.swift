//
//  DataManager.swift
//  instructor
//
//  Created by edge on 2025/12/23.
//

import SwiftUI

protocol CardDataManaging {
    func fetchCards() -> [DemoCard]
}

final class CardDataManager: CardDataManaging {
    func fetchCards() -> [DemoCard] {
        [
            DemoCard(title: "向左/右滑动", subtitle: "使用原生 TabView 页签样式", color: .blue),
            DemoCard(title: "可扩展", subtitle: "将卡片替换为自定义组件", color: .green),
            DemoCard(title: "天然分页", subtitle: "支持手势与页面指示器", color: .purple)
        ]
    }
}

