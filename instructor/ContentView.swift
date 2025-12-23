//
//  ContentView.swift
//  instructor
//
//  Created by edge on 2025/12/23.
//

import SwiftUI

struct DemoCard: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let color: Color
}

struct DemoCardView: View {
    let card: DemoCard

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(card.title)
                .font(.title2.weight(.semibold))
            Text(card.subtitle)
                .font(.callout)
                .foregroundStyle(.secondary)
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "hand.point.right.fill")
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(card.color.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct ContentView: View {
    private let cards: [DemoCard]

    init(dataManager: CardDataManaging = CardDataManager()) {
        self.cards = dataManager.fetchCards()
    }

    var body: some View {
        TabView {
            ForEach(cards) { card in
                DemoCardView(card: card)
                    .padding(.horizontal, 24)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .padding(.vertical, 32)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    ContentView()
}
