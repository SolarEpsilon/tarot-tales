//
//  MainMenuView.swift
//  tarot card app
//
//  Created by Ronan M on 1/20/25.
//

import SwiftUI

// MARK: - Main Menu
struct MainMenuView: View {
    @State private var realisticDraw = false
    @State private var navigateToCardView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Title
                Text("Tarot Tales")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .foregroundColor(.brown)
                
                // Toggle for turning on/off realisitc draw mode
                VStack {
                    Text("Choose Draw Mode")
                        .font(.headline)
                    
                    Toggle("Realistic Draw (no repeats)", isOn: $realisticDraw)
                        .padding()
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                }
                
                Spacer()
                
                // Button to open tarot card view
                NavigationLink(destination: TarotCardView(realisticDraw: realisticDraw), isActive: $navigateToCardView
                ) {
                    Text("Start Reading")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 50)
                }
                
                Spacer()
            }
            .padding()
            .background(LinearGradient(
                gradient: Gradient(colors: [.white, .yellow.opacity(0.3)]),
                startPoint: .top, endPoint: .bottom
            ))
            .navigationBarHidden(true)
        }
    }
}
