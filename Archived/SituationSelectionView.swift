//
//  SituationSelectionView.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//

import SwiftUI

// MARK: - 选择处境
struct SituationSelectionView: View {
    @State private var selectedSituation: Situation?
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 0) {
            // 标题
            Text("你现在的状态是？")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.primary)
                .padding(.top, 60)
                .padding(.bottom, 40)
            
            // 选项列表
            VStack(spacing: 20) {
                ForEach(Situation.allCases, id: \.self) { situation in
                    Button(action: {
                        selectedSituation = situation
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: selectedSituation == situation ? "circle.fill" : "circle")
                                .font(.system(size: 16))
                                .foregroundStyle(selectedSituation == situation ? .primary : .secondary)
                            
                            Text(situation.displayName)
                                .font(.system(size: 17))
                                .foregroundStyle(.primary)
                            
                            Spacer()
                        }
                        .padding(.vertical, 12)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // 确认按钮
            if selectedSituation != nil {
                Button(action: {
                    if let situation = selectedSituation {
                        navigationPath.append(NavigationDestination.quoteDisplay(situation))
                    }
                }) {
                    Text("确认")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.primary)
                        .frame(width: 120, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                }
                .padding(.bottom, 60)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        SituationSelectionView(navigationPath: $path)
    }
}
