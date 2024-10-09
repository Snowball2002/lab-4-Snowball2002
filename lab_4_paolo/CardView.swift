//  CardView.swift
//  lab_4_paolo
//
//  Created by Paolo Lauricellaon 10/8/24.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var onswipedleft: (() -> Void)?  // Fixed the type from void to Void
    var onswipedright: (() -> Void)?  // Fixed the type from void to Void
    @State private var isShowingQuestion = true
    
    @State private var offset: CGSize = .zero
    
    private let swipeThreshold: Double = 200
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(offset.width < 0 ? .red : .green)
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(isShowingQuestion ? Color.blue : Color.indigo)
                    .shadow(color: .black, radius: 4, x: -2, y: 2)
                    .opacity(1 - abs(offset.width) / swipeThreshold)
            }
            
            VStack(spacing: 20) {
                Text(isShowingQuestion ? "Question" : "Answer")
                    .bold()
                Rectangle()
                    .frame(height: 1)
                
                Text(isShowingQuestion ? card.question : card.answer)
            }
            .font(.title)
            .foregroundStyle(.white)
            .padding()
        }
        .frame(width: 300, height: 500)
        .onTapGesture {
            isShowingQuestion.toggle()
        }
        .opacity(3 - abs(offset.width) / swipeThreshold * 3)
        .rotationEffect(.degrees(offset.width / 20.0))
        .offset(CGSize(width: offset.width, height: 0))
        .gesture(DragGesture()
            .onChanged { gesture in
                let translation = gesture.translation
                print(translation)
                offset = translation
            }
            .onEnded { gesture in
                if gesture.translation.width > swipeThreshold {
                    onswipedright?()
                    print("👉 Swiped right")
                } else if gesture.translation.width < -swipeThreshold {
                    print("👈 Swiped left")
                    onswipedleft?()
                } else {
                    print("🚫 Swipe canceled")
                    withAnimation(.spring()) {  // Changed to .spring() for animation
                        offset = .zero
                    }
                }
            }
        )
    }
}

#Preview {
    CardView(card: Card(
        question: "Located at the southern end of Puget Sound, what is the capital of Washington?",
        answer: "Olympia"
    ))
}

struct Card: Equatable {
    let question: String
    let answer: String

    static let mockedCards = [
        Card(question: "Located at the southern end of Puget Sound, what is the capital of Washington?", answer: "Olympia"),
        Card(question: "Who painted the Mona Lisa?", answer: "Leonardo da Vinci"),
        Card(question: "Who wrote the play 'Romeo and Juliet'?", answer: "Shakespeare"),
        Card(question: "What year did the Titanic sink?", answer: "1912"),
        Card(question: "What is the largest planet in our solar system?", answer: "Jupiter")
    ]
}


