//
//  AppSettingsView.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//

import SwiftUI

// MARK: - 设置页面
struct AppSettingsView: View {
    @State private var showClearConfirmation: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    private let dataManager = QuoteDataManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("这是一个工具")
                            .font(.system(size: 15, weight: .medium))
                        
                        Text("当你犹豫、退缩、想逃的时候，")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                        
                        Text("用一句话让你站直。")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                        
                        Divider()
                            .padding(.vertical, 4)
                        
                        Text("数据存储：本地")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                        
                        Text("没有登录，没有云端，没有社交。")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("使用说明")
                }
                
                Section {
                    Button(role: .destructive, action: {
                        showClearConfirmation = true
                    }) {
                        HStack {
                            Text("清空所有记录")
                            Spacer()
                            Image(systemName: "trash")
                        }
                    }
                } header: {
                    Text("数据管理")
                } footer: {
                    Text("清空后无法恢复")
                        .font(.system(size: 12))
                }
                
                Section {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
            .confirmationDialog(
                "确认清空所有记录？",
                isPresented: $showClearConfirmation,
                titleVisibility: .visible
            ) {
                Button("清空", role: .destructive) {
                    dataManager.clearAllRecords()
                }
                Button("取消", role: .cancel) {}
            }
        }
    }
}

#Preview {
    AppSettingsView()
}

