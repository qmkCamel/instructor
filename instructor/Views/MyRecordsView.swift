//
//  MyRecordsView.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//

import SwiftUI

struct MyRecordsView: View {
    private let dataManager = QuoteDataManager.shared
    @State private var records: [QuoteRecord] = []
    @State private var selectedRecord: QuoteRecord?
    
    var body: some View {
        Group {
            if records.isEmpty {
                emptyStateView
            } else {
                recordsListView
            }
        }
        .navigationTitle("我的记录")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadRecords()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("还没有记录")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.secondary)
            
            Text("去抽一句吧")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
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
                    
                    Divider()
                        .padding(.leading, 20)
                }
            }
        }
        .background(Color(.systemBackground))
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
            HStack(spacing: 12) {
                Text(record.dateString)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
                
                Text(record.situation.displayName)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            
            Text(record.quote.content)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            HStack(spacing: 8) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                
                Text(record.action.displayName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(actionColor(for: record.action))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private func actionColor(for action: ActionChoice) -> Color {
        switch action {
        case .did: return .primary
        case .didNot: return .secondary
        case .avoided: return .secondary
        }
    }
}

struct RecordDetailView: View {
    let record: QuoteRecord
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 16) {
                        Text("状态：")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.secondary)
                        Text(record.situation.displayName)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.primary)
                    }
                    
                    HStack(spacing: 16) {
                        Text("时间：")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.secondary)
                        Text(record.dateString)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.primary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32)
                .padding(.top, 40)
                
                Spacer()
                    .frame(height: 60)
                
                VStack(spacing: 24) {
                    Text(record.quote.content)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(6)
                    
                    Text("——《\(record.quote.source)》")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 32)
                
                Spacer()
                    .frame(height: 60)
                
                HStack(spacing: 12) {
                    Text("我的选择：")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.secondary)
                    Text(record.action.displayName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyRecordsView()
    }
}

