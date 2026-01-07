//
//  HomeView.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//

import SwiftUI

// MARK: - 首页（极空）
struct HomeView: View {
    @State private var showSituationSelection: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()
                
                // 主标题
                VStack(spacing: 16) {
                    Text("给我一句")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(.primary)
                    
                    Text("现在能站住的话")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 60)
                
                // 开始按钮
                Button(action: {
                    showSituationSelection = true
                }) {
                    Text("开始")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.primary)
                        .frame(width: 120, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: MyRecordsView()) {
                    Image(systemName: "clock")
                        .foregroundStyle(.primary)
                }
            }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: QuotePoolView()) {
                        Image(systemName: "book")
                            .foregroundStyle(.primary)
                    }
                }
            }
            .navigationDestination(isPresented: $showSituationSelection) {
                SituationSelectionView()
            }
        }
    }
}

#Preview {
    HomeView()
}
