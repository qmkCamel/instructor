//
//  QuoteDisplayView.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//

import SwiftUI

// MARK: - 语录展示（冷处理）
struct QuoteDisplayView: View {
    let situation: Situation
    @Binding var navigationPath: NavigationPath
    @State private var quote: Quote?
    
    private let dataManager = QuoteDataManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            if let quote = quote {
                // 语录内容
                VStack(spacing: 24) {
                    Text(quote.content)
                        .font(.system(size: 22, weight: .regular))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.horizontal, 40)
                    
                    Text("——《\(quote.source)》")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // 向下滑动提示
                VStack(spacing: 8) {
                    Text("向下滑动")
                        .font(.system(size: 14))
                        .foregroundStyle(.tertiary)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundStyle(.tertiary)
                }
                .padding(.bottom, 40)
            } else {
                ProgressView()
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // 返回首页：清空导航路径
                    navigationPath.removeLast(navigationPath.count)
                }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(.primary)
                }
            }
        }
        .onAppear {
            loadQuote()
        }
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.height > 0, let quote = quote {
                        navigationPath.append(NavigationDestination.actionConfirmation(quote, situation))
                    }
                }
        )
    }
    
    private func loadQuote() {
        quote = dataManager.getRandomQuote(for: situation)
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        QuoteDisplayView(situation: .hesitating, navigationPath: $path)
    }
}
