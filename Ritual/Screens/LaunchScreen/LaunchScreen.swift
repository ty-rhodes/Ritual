//
//  LaunchScreen.swift
//  Ritual
//
//  Created by Tyler Rhodes on 9/25/23.
//

import SwiftUI

struct LaunchScreen: View {
    
    @Binding var isPresented: Bool
    
    @State private var scale = CGSize(width: 0.8, height: 0.8)
    
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            Theme.homeBackground
                .ignoresSafeArea()
//            Image("launch-logo")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 200)
//                .scaleEffect(scale)
            LottieView(name: Animations.progress, loopMode: .repeat(2), animationSpeed: 1)
                .frame(width: 200, height: 200)
                .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.5)) {
                scale = CGSize(width: 1, height: 1)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                withAnimation(.easeInOut(duration: 0.35)) {
                    scale = CGSize(width: 50, height: 50)
                    opacity = 0
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.9, execute: {
                withAnimation(.easeInOut(duration: 0)) {
                    isPresented.toggle()
                }
            })
        }
    }
}

#Preview {
    LaunchScreen(isPresented: .constant(true))
}
