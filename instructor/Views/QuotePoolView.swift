//
//  QuotePoolView.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//

import SwiftUI

// MARK: - 主题颜色
private let themeTextPrimary = Color(red: 0.20, green: 0.20, blue: 0.18)
private let themeTextSecondary = Color(red: 0.45, green: 0.43, blue: 0.40)
private let themeTextTertiary = Color(red: 0.60, green: 0.58, blue: 0.55)
private let themeBackground = LinearGradient(
    colors: [
        Color(red: 0.98, green: 0.97, blue: 0.95),
        Color(red: 0.96, green: 0.94, blue: 0.91)
    ],
    startPoint: .top,
    endPoint: .bottom
)

// MARK: - 语录池（只读）
struct QuotePoolView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedIndex: Int = 0
    
    private let dataManager = QuoteDataManager.shared
    private let situations = Situation.allCases
    
    var body: some View {
        ZStack {
            themeBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 顶部分类标题
                HStack(spacing: 0) {
                    ForEach(Array(situations.enumerated()), id: \.element) { index, situation in
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedIndex = index
                            }
                        } label: {
                            Text(situation.emoji)
                                .font(.system(size: 22))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .opacity(selectedIndex == index ? 1.0 : 0.35)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // 当前分类名称
                Text(situations[selectedIndex].categoryName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(themeTextSecondary)
                    .tracking(0.5)
                    .padding(.bottom, 12)
                
                // 左右滑动的语录列表
                TabView(selection: $selectedIndex) {
                    ForEach(Array(situations.enumerated()), id: \.element) { index, situation in
                        QuoteListView(quotes: dataManager.getQuotes(for: situation))
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: selectedIndex)
            }
        }
        .navigationTitle("语录池")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(themeBackground, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("完成") {
                    dismiss()
                }
                .foregroundStyle(themeTextSecondary)
            }
        }
    }
}

// MARK: - 语录列表视图
struct QuoteListView: View {
    let quotes: [Quote]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(quotes) { quote in
                    QuotePoolRow(quote: quote)
                    
                    if quote.id != quotes.last?.id {
                        Rectangle()
                            .fill(themeTextTertiary.opacity(0.2))
                            .frame(height: 1)
                            .padding(.horizontal, 28)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}

// MARK: - 语录池行
struct QuotePoolRow: View {
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(quote.content)
                .font(.system(size: 16, weight: .regular, design: .serif))
                .foregroundStyle(themeTextPrimary)
                .lineSpacing(6)
                .multilineTextAlignment(.leading)
            
            HStack {
                Spacer()
                Text("——《\(quote.source)》")
                    .font(.system(size: 13))
                    .foregroundStyle(themeTextTertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 28)
        .padding(.vertical, 20)
    }
}

#Preview {
    NavigationStack {
        QuotePoolView()
    }
}

