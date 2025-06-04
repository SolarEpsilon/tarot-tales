//
//  TarotCardView.swift
//  tarot card app
//
//  Created by Ronan M on 1/20/25.
//

import SwiftUI

struct TarotCardView: View {
    let realisticDraw: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var deck = (0...77).flatMap { [$0, $0 + 100] }.shuffled()
    @State private var currentCard: Int? = nil
    @State private var previousCard: Int? = nil
    @State private var showCardBack = true
    @State private var cardNames: [Int: String] = [:]
    @State private var isViewingPreviousCard = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            if (realisticDraw && deck.isEmpty) {
                // Display message when all cards are drawn
                VStack {
                    Text("All cards have been drawn!")
                        .font(.title)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: resetDeck) {
                        Text("Reset Deck")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
            } else if (showCardBack) {
                Image("-1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 450)
                
                Text("Click to draw...")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Spacer()
                
                Button(action: refreshCard) {
                    Text("Draw")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            } else {
                // Display current card
                Image("\(currentCard ?? -1)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 450)
                
                Text(getCardName(currentCard ?? -1))
                    .font(.largeTitle)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Spacer()
                
                HStack {
                    // Previous card button
                    Button(action: goToPreviousCard) {
                        Text("Previous")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(previousCard != nil && !isViewingPreviousCard ? Color.blue : Color.gray)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .disabled(previousCard == nil || isViewingPreviousCard)
                    
                    // Draw button
                    Button(action: refreshCard) {
                        Text("Draw")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .disabled(deck.isEmpty)
                }
                .padding()
            }
        }
        .padding()
        .onAppear() {
            cardNames = loadCardNames()
        }
    }
    
    func refreshCard() {
        if showCardBack {
            // First draw
            currentCard = deck.removeFirst()
            showCardBack = false
            isViewingPreviousCard = false
        } else {
            if isViewingPreviousCard {
                // If we're viewing the previous card and draw again,
                // we should discard the previous card
                previousCard = nil
            } else {
                // Store current card as previous before drawing new one
                previousCard = currentCard
            }
            
            isViewingPreviousCard = false
            
            if realisticDraw {
                // Draw next card from deck
                currentCard = deck.removeFirst()
            } else {
                // Draw random card
                currentCard = deck[Int.random(in: 0..<deck.count)]
            }
        }
    }
    
    func goToPreviousCard() {
        if let previous = previousCard, !isViewingPreviousCard {
            // Swap current and previous cards
            let temp = currentCard
            currentCard = previous
            previousCard = temp
            isViewingPreviousCard = true
        }
    }
    
    func resetDeck() {
        deck = (0...77).flatMap { [$0, $0 + 100] }.shuffled()
        showCardBack = true
        currentCard = nil
        previousCard = nil
        isViewingPreviousCard = false
    }
    
    func getCardName(_ cardIndex: Int) -> String {
        return cardNames[cardIndex] ?? "Unknown Card"
    }
    
    func loadCardNames() -> [Int: String] {
        guard let path = Bundle.main.path(forResource: "cards", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let cardNames = try? JSONDecoder().decode([String: String].self, from: data)
        else {
            return [:]
        }
        
        return cardNames.reduce(into: [Int: String]()) { result, pair in
            if let key = Int(pair.key) {
                result[key] = pair.value
            }
        }
    }
}

#Preview {
    TarotCardView(realisticDraw: true)
}
