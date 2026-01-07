//
//  CompletionView.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//

import SwiftUI

// MARK: - 完成页面（立刻退场）
struct CompletionView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 24) {
                Text("已记录。")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.primary)
                
                Text("去做你的事。")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            // 2秒后自动关闭
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                dismiss()
            }
        }
    }
}

#Preview {
    CompletionView()
}
