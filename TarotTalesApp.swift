//
// TarotTalesApp.swift
//  tarot card app
//
//  Created by Ronan M on 12/25/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var navigateToMain = false
    
    var body: some View {
        if navigateToMain {
            MainMenuView()
        } else {
            VStack {
                Spacer()
                Image("tarot-tales-logo")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                Spacer()
            }
            .background(Color.black)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    navigateToMain = true
                }
            }
        }
    }
}

@main
struct TarotTalesApp: App {
    var body: some Scene {
        WindowGroup {
            LoadingView()
        }
    }
}
