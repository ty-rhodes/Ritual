//
//  LaunchScreen.swift
//  Ritual
//
//  Created by Tyler Rhodes on 9/25/23.
//

import SwiftUI
import Lottie

struct LaunchScreen: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Theme.brewBackground
                .ignoresSafeArea()
            LottieView(name: Animations.welcome, loopMode: .playOnce, animationSpeed: 1)
                .ignoresSafeArea()
        }
        .onAppear {
            let animationDuration = LottieAnimation.named(Animations.welcome)?.duration ?? 1
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration, execute: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isPresented.toggle()
                }
            })
        }
    }
}

#Preview {
    LaunchScreen(isPresented: .constant(true))
}
