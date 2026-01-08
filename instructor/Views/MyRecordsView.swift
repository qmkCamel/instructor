//
//  MyRecordsView.swift
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

struct MyRecordsView: View {
    @Environment(\.dismiss) private var dismiss
    private let dataManager = QuoteDataManager.shared
    @State private var records: [QuoteRecord] = []
    @State private var selectedRecord: QuoteRecord?
    
    var body: some View {
        ZStack {
            themeBackground.ignoresSafeArea()
            
            Group {
                if records.isEmpty {
                    emptyStateView
                } else {
                    recordsListView
                }
            }
        }
        .navigationTitle("我的记录")
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
        .onAppear {
            loadRecords()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("还没有记录")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(themeTextSecondary)
            
            Text("去抽一句吧")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(themeTextTertiary)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var recordsListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(records) { record in
                    Button {
                        selectedRecord = record
                    } label: {
                        RecordRowView(record: record)
                    }
                    .buttonStyle(.plain)
                    
                    if record.id != records.last?.id {
                        Rectangle()
                            .fill(themeTextTertiary.opacity(0.2))
                            .frame(height: 1)
                            .padding(.horizontal, 24)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .sheet(item: $selectedRecord) { record in
            RecordDetailView(record: record)
        }
    }
    
    private func loadRecords() {
        records = dataManager.getAllRecords()
    }
}

struct RecordRowView: View {
    let record: QuoteRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(formatDate(record.timestamp))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(themeTextTertiary)
                
                Text("·")
                    .foregroundStyle(themeTextTertiary)
                
                Text(record.situation.displayNameWithEmoji)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(themeTextTertiary)
            }
            
            Text(record.quote.content)
                .font(.system(size: 16, weight: .regular, design: .serif))
                .foregroundStyle(themeTextPrimary)
                .lineLimit(2)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
            
            Text(record.action.displayNameWithEmoji)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(themeTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

struct RecordDetailView: View {
    let record: QuoteRecord
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 12) {
                            Text("状态")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(themeTextTertiary)
                            Text(record.situation.displayNameWithEmoji)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(themeTextSecondary)
                        }
                        
                        HStack(spacing: 12) {
                            Text("时间")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(themeTextTertiary)
                            Text(formatDate(record.timestamp))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(themeTextSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 32)
                    .padding(.top, 40)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    VStack(spacing: 20) {
                        Text(record.quote.content)
                            .font(.system(size: 22, weight: .regular, design: .serif))
                            .foregroundStyle(themeTextPrimary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                        
                        Text("——《\(record.quote.source)》")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(themeTextTertiary)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    HStack(spacing: 8) {
                        Text("我的选择")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(themeTextTertiary)
                        Text(record.action.displayNameWithEmoji)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(themeTextSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(themeBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                    .foregroundStyle(themeTextSecondary)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        MyRecordsView()
    }
}
