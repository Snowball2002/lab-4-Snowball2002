//  ContentView.swift
//  lab_4_paolo
//
//  Created by Paolo Lauricella on 10/8/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var cards: [Card] = Card.mockedCards
    @State private var deckid: Int = 0
    @State private var cardsToPractice: [Card] = []
    @State private var cardsMemorized: [Card] = []
    
    @State private var createCardViewPresented = false
    
    var body: some View {
        VStack {
            Button("Reset") {
                cards = cardsToPractice + cardsMemorized
                cardsToPractice = []
                cardsMemorized = []
                deckid += 1
            }
            .disabled(cardsToPractice.isEmpty && cardsMemorized.isEmpty)

            Button("More Practice") {
                cards = cardsToPractice
                cardsToPractice = []
                deckid += 1
            }
            .disabled(cardsToPractice.isEmpty)
        }

        ZStack {
            ForEach(0..<cards.count, id: \.self) { index in
                CardView(card: cards[index], onswipedleft: {
                    let removedCard = cards.remove(at: index)
                    cardsToPractice.append(removedCard)
                },
                onswipedright: {
                    let removedCard = cards.remove(at: index)
                    cardsMemorized.append(removedCard)
                })
                .rotationEffect(.degrees(Double(cards.count - 1 - index) * -5))
            }
        }
        .animation(.spring(), value: cards)
        .id(deckid)
        .sheet(isPresented: $createCardViewPresented, content: {
            CreateFlashcardView { card in
                cards.append(card)
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            Button("Add Flashcard", systemImage: "plus") {
                createCardViewPresented.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}
