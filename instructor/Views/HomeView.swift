//
//  HomeView.swift
//  instructor
//
//  Created by edge on 2025/12/26.
//

import SwiftUI

// MARK: - 流程阶段
enum FlowPhase: Equatable {
    case idle                           // 初始状态
    case selectingSituation             // 选择处境
    case showingQuote(Situation)        // 展示语录
    case selectingAction(Quote, Situation)  // 选择行动
    case completed                      // 完成
}

// MARK: - 首页（单页流程）
struct HomeView: View {
    @State private var phase: FlowPhase = .idle
    @State private var selectedSituation: Situation?
    @State private var currentQuote: Quote?
    @State private var selectedAction: ActionChoice?
    @State private var lastRecord: QuoteRecord?
    @State private var showingRecords = false
    @State private var showingQuotePool = false
    
    private let dataManager = QuoteDataManager.shared
    
    // 触觉反馈生成器
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let selectionFeedback = UISelectionFeedbackGenerator()
    private let notificationFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 柔和高级的渐变背景
                LinearGradient(
                    colors: [
                        Color(red: 0.98, green: 0.97, blue: 0.95),  // 温暖的奶油白
                        Color(red: 0.96, green: 0.94, blue: 0.91)   // 淡米色
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 顶部已选内容区域
                    topContentView
                    
                    Spacer()
                    
                    // 中间主内容区域
                    centerContentView
                    
                    Spacer()
                    
                    // 底部按钮区域
                    bottomButtonView
                }
                .padding(.horizontal, 40)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        impactLight.impactOccurred()
                        showingRecords = true
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(themeTextSecondary)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color(red: 0.92, green: 0.90, blue: 0.87).opacity(0.6))
                            )
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        impactLight.impactOccurred()
                        showingQuotePool = true
                    } label: {
                        Image(systemName: "text.book.closed")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(themeTextSecondary)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color(red: 0.92, green: 0.90, blue: 0.87).opacity(0.6))
                            )
                    }
                }
            }
            .sheet(isPresented: $showingRecords) {
                NavigationStack {
                    MyRecordsView()
                }
            }
            .sheet(isPresented: $showingQuotePool) {
                NavigationStack {
                    QuotePoolView()
                }
            }
            .onAppear {
                loadLastRecord()
            }
            .onChange(of: showingRecords) { _, isShowing in
                if !isShowing {
                    loadLastRecord()
                }
            }
        }
    }
    
    // MARK: - 加载最近记录
    private func loadLastRecord() {
        lastRecord = dataManager.getAllRecords().first
    }
    
    // MARK: - 主题颜色
    private var themeTextPrimary: Color { Color(red: 0.20, green: 0.20, blue: 0.18) }
    private var themeTextSecondary: Color { Color(red: 0.45, green: 0.43, blue: 0.40) }
    private var themeTextTertiary: Color { Color(red: 0.60, green: 0.58, blue: 0.55) }
    
    // MARK: - 顶部已选内容
    @ViewBuilder
    private var topContentView: some View {
        VStack(spacing: 16) {
            // idle 状态显示最近一次记录
            if phase == .idle, let record = lastRecord {
                VStack(spacing: 14) {
                    Text("\(formatDate(record.timestamp)) · \(record.situation.displayNameWithEmoji)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(themeTextTertiary)
                        .tracking(0.5)
                    
                    Text(record.quote.content)
                        .font(.system(size: 15, weight: .regular, design: .serif))
                        .foregroundStyle(themeTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                    
                    Text(record.action.displayNameWithEmoji)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(themeTextTertiary)
                }
                .transition(.opacity)
            }
            
            // 显示已选择的处境
            if let situation = selectedSituation, phase != .selectingSituation && phase != .idle {
                Text(situation.displayNameWithEmoji)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(themeTextSecondary)
                    .tracking(0.3)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
            
            // 显示语录（当在选择行动或完成阶段时）
            if let quote = currentQuote, (isInActionPhase || phase == .completed) {
                VStack(spacing: 12) {
                    Text(quote.content)
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundStyle(themeTextPrimary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                    
                    Text("——《\(quote.source)》")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(themeTextTertiary)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
            }
            
            // 显示已选择的行动（完成阶段）
            if let action = selectedAction, phase == .completed {
                Text(action.displayNameWithEmoji)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(themeTextSecondary)
                    .padding(.top, 8)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .padding(.top, 60)
        .animation(.easeInOut(duration: 0.4), value: phase)
    }
    
    // MARK: - 中间主内容
    @ViewBuilder
    private var centerContentView: some View {
        Group {
            switch phase {
            case .idle:
                // 初始标题
                VStack(spacing: 20) {
                    Text("给我一句")
                        .font(.system(size: 32, weight: .semibold, design: .serif))
                        .foregroundStyle(themeTextPrimary)
                        .tracking(2)
                    
                    Text("现在能站住的话")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(themeTextSecondary)
                        .tracking(1)
                }
                .transition(.opacity)
                
            case .selectingSituation:
                // 选择处境
                VStack(spacing: 28) {
                    Text("你现在的状态是？")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(themeTextPrimary)
                        .tracking(0.5)
                    
                    VStack(spacing: 0) {
                        ForEach(Situation.allCases, id: \.self) { situation in
                            Button(action: {
                                selectionFeedback.selectionChanged()
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedSituation = situation
                                }
                            }) {
                                HStack(spacing: 14) {
                                    Circle()
                                        .fill(selectedSituation == situation ? themeTextPrimary : Color.clear)
                                        .frame(width: 8, height: 8)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedSituation == situation ? themeTextPrimary : themeTextTertiary, lineWidth: 1.5)
                                        )
                                    
                                    Text(situation.displayNameWithEmoji)
                                        .font(.system(size: 16, weight: selectedSituation == situation ? .medium : .regular))
                                        .foregroundStyle(selectedSituation == situation ? themeTextPrimary : themeTextSecondary)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 14)
                            }
                            
                            if situation != Situation.allCases.last {
                                Divider()
                                    .background(themeTextTertiary.opacity(0.3))
                            }
                        }
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
                
            case .showingQuote:
                // 展示语录
                if let quote = currentQuote {
                    VStack(spacing: 28) {
                        Text(quote.content)
                            .font(.system(size: 24, weight: .regular, design: .serif))
                            .foregroundStyle(themeTextPrimary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                        
                        Text("——《\(quote.source)》")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(themeTextTertiary)
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                }
                
            case .selectingAction:
                // 选择行动
                VStack(spacing: 28) {
                    Text("面对这句话")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(themeTextPrimary)
                        .tracking(0.5)
                    
                    VStack(spacing: 0) {
                        ForEach(ActionChoice.allCases, id: \.self) { action in
                            Button(action: {
                                selectionFeedback.selectionChanged()
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedAction = action
                                }
                            }) {
                                HStack(spacing: 14) {
                                    Circle()
                                        .fill(selectedAction == action ? themeTextPrimary : Color.clear)
                                        .frame(width: 8, height: 8)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedAction == action ? themeTextPrimary : themeTextTertiary, lineWidth: 1.5)
                                        )
                                    
                                    Text(action.displayNameWithEmoji)
                                        .font(.system(size: 16, weight: selectedAction == action ? .medium : .regular))
                                        .foregroundStyle(selectedAction == action ? themeTextPrimary : themeTextSecondary)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 14)
                            }
                            
                            if action != ActionChoice.allCases.last {
                                Divider()
                                    .background(themeTextTertiary.opacity(0.3))
                            }
                        }
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
                
            case .completed:
                // 完成
                VStack(spacing: 20) {
                    Text("已记录")
                        .font(.system(size: 26, weight: .semibold, design: .serif))
                        .foregroundStyle(themeTextPrimary)
                        .tracking(2)
                    
                    Text("去做你的事")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(themeTextSecondary)
                        .tracking(1)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
                .onAppear {
                    // 2秒后返回初始状态
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        resetFlow()
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: phase)
    }
    
    // MARK: - 底部按钮
    @ViewBuilder
    private var bottomButtonView: some View {
        Group {
            switch phase {
            case .idle:
                Button(action: {
                    impactMedium.impactOccurred()
                    withAnimation(.easeInOut(duration: 0.4)) {
                        phase = .selectingSituation
                    }
                }) {
                    Text("开始")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(red: 0.35, green: 0.35, blue: 0.32)) // 温暖的深灰褐色
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .transition(.opacity)
                
            case .selectingSituation:
                if selectedSituation != nil {
                    Button(action: {
                        impactMedium.impactOccurred()
                        loadQuoteAndProceed()
                    }) {
                        Text("确认")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(red: 0.35, green: 0.35, blue: 0.32))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .transition(.opacity)
                }
                
            case .showingQuote:
                Button(action: {
                    impactLight.impactOccurred()
                    proceedToAction()
                }) {
                    Text("下一步")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(red: 0.35, green: 0.35, blue: 0.32))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .transition(.opacity)
                
            case .selectingAction:
                Button(action: {
                    notificationFeedback.notificationOccurred(.success)
                    saveAndComplete()
                }) {
                    Text("记录")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(selectedAction == nil ? Color(red: 0.75, green: 0.73, blue: 0.70) : Color(red: 0.35, green: 0.35, blue: 0.32))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .disabled(selectedAction == nil)
                .transition(.opacity)
                
            case .completed:
                EmptyView()
            }
        }
        .padding(.bottom, 50)
        .animation(.easeInOut(duration: 0.3), value: phase)
        .animation(.easeInOut(duration: 0.3), value: selectedSituation)
        .animation(.easeInOut(duration: 0.3), value: selectedAction)
    }
    
    // MARK: - Helper
    private var isInActionPhase: Bool {
        if case .selectingAction = phase { return true }
        return false
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // MARK: - Actions
    private func loadQuoteAndProceed() {
        guard let situation = selectedSituation else { return }
        currentQuote = dataManager.getRandomQuote(for: situation)
        withAnimation(.easeInOut(duration: 0.4)) {
            phase = .showingQuote(situation)
        }
    }
    
    private func proceedToAction() {
        guard let quote = currentQuote, let situation = selectedSituation else { return }
        withAnimation(.easeInOut(duration: 0.4)) {
            phase = .selectingAction(quote, situation)
        }
    }
    
    private func saveAndComplete() {
        guard let action = selectedAction,
              let quote = currentQuote,
              let situation = selectedSituation else { return }
        
        // 保存记录
        let record = QuoteRecord(
            quote: quote,
            situation: situation,
            action: action
        )
        dataManager.saveRecord(record)
        
        // 保存到 Widget
        saveToWidget(quote: quote, situation: situation, action: action)
        
        withAnimation(.easeInOut(duration: 0.4)) {
            phase = .completed
        }
    }
    
    private func saveToWidget(quote: Quote, situation: Situation, action: ActionChoice) {
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
    
    private func resetFlow() {
        withAnimation(.easeInOut(duration: 0.4)) {
            phase = .idle
            selectedSituation = nil
            currentQuote = nil
            selectedAction = nil
        }
        // 更新最近记录
        loadLastRecord()
    }
}

#Preview {
    HomeView()
}
