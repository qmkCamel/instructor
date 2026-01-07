//
//  ActionConfirmationView.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//

import SwiftUI

struct ActionConfirmationView: View {
    let quote: Quote
    let situation: Situation
    
    @State private var selectedAction: ActionChoice?
    @State private var showCompletion = false
    private let dataManager = QuoteDataManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Text("面对这句话：")
                .font(.system(size: 20, weight: .regular))
                .padding(.top, 60)
                .padding(.bottom, 40)
            
            VStack(spacing: 20) {
                ForEach(ActionChoice.allCases, id: \.self) { action in
                    Button {
                        selectedAction = action
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: selectedAction == action ? "circle.fill" : "circle")
                                .font(.system(size: 20))
                                .foregroundStyle(.primary)
                            
                            Text(action.displayName)
                                .font(.system(size: 18, weight: .regular))
                                .foregroundStyle(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                        .contentShape(Rectangle())
                    }
                }
            }
            
            Spacer()
            
            Button {
                if let action = selectedAction {
                    saveRecord(action: action)
                    showCompletion = true
                }
            } label: {
                Text("记录")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(selectedAction == nil ? .secondary : .primary)
                    .frame(width: 120, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedAction == nil ? Color.secondary : Color.primary, lineWidth: 1)
                    )
            }
            .disabled(selectedAction == nil)
            .padding(.bottom, 80)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showCompletion) {
            CompletionView()
        }
    }
    
    private func saveRecord(action: ActionChoice) {
        let record = QuoteRecord(
            quote: quote,
            situation: situation,
            action: action
        )
        dataManager.saveRecord(record)
        
        // 同时保存到共享存储，供 Widget 显示
        saveToWidget(action: action)
    }
    
    private func saveToWidget(action: ActionChoice) {
        let sharedQuote = SharedQuote(content: quote.content, source: quote.source)
        let sharedSituation = mapSituation(situation)
        let sharedAction = mapAction(action)
        
        let sharedRecord = SharedLastRecord(
            quote: sharedQuote,
            situation: sharedSituation,
            action: sharedAction,
            timestamp: Date()
        )
        
        SharedDataManager.shared.saveLastRecord(sharedRecord)
    }
    
    private func mapSituation(_ situation: Situation) -> SharedSituation {
        switch situation {
        case .hesitating: return .hesitating
        case .retreating: return .retreating
        case .struggling: return .struggling
        case .passive: return .passive
        }
    }
    
    private func mapAction(_ action: ActionChoice) -> SharedActionChoice {
        switch action {
        case .did: return .did
        case .didNot: return .didNot
        case .avoided: return .avoided
        }
    }
}

#Preview {
    NavigationStack {
        ActionConfirmationView(
            quote: Quote(content: "没有调查，就没有发言权。", source: "反对本本主义", situation: .hesitating),
            situation: .hesitating
        )
    }
}

