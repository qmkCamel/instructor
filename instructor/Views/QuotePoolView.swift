//
//  QuotePoolView.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//

import SwiftUI

// MARK: - 语录池（只读）
struct QuotePoolView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSituation: Situation = .hesitating
    
    private let dataManager = QuoteDataManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // 处境选择器
            Picker("处境", selection: $selectedSituation) {
                ForEach(Situation.allCases, id: \.self) { situation in
                    Text(situation.categoryName)
                        .tag(situation)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // 语录列表
            List {
                let quotes = dataManager.getQuotes(for: selectedSituation)
                
                ForEach(quotes) { quote in
                    QuotePoolRow(quote: quote)
                        .listRowInsets(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("语录池")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("完成") {
                    dismiss()
                }
            }
        }
    }
}

// MARK: - 语录池行
struct QuotePoolRow: View {
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(quote.content)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.primary)
                .lineSpacing(4)
            
            Text("——《\(quote.source)》")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        QuotePoolView()
    }
}

