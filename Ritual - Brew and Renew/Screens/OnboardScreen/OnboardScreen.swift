//
//  OnboardScreen.swift
//  Ritual
//
//  Created by Tyler Rhodes on 12/21/23.
//

import SwiftUI

struct OnboardScreen: View {
    // Visibility Status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    var body: some View {
        ZStack {
            Theme.homeBackground
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack(spacing: 15) {
                Text("Welcome to \nRitual")
                    .font(.system(size: 40, weight: .light))
                    .multilineTextAlignment(.center)
                    .padding(.top, 65)
                    .padding(.bottom, 35)
                
                // Points View
                VStack(alignment: .leading, spacing: 25) {
                    PointView(symbol: "book.pages",
                              title: "Log Entries",
                              subTitle: "Write and log your own journal entries to meditate and look back on.")
                    
                    PointView(symbol: "pencil.and.list.clipboard", 
                              title: "Save Recipes",
                              subTitle: "Create and save your brew recipes for your future reference.")
                    
                    PointView(symbol: "mug", 
                              title: "Brew and Renew!",
                              subTitle: "Brew your desired method within the brew flow.")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                
                Spacer()
                
                Button(action: {
                    isFirstTime = false
                }, label: {
                    Text("Get Started")
                        .frame(width: 350, height: 50)
                        .background(.white)
                        .foregroundStyle(.black)
                        .font(.system(size: 16, weight: .semibold))
                        .cornerRadius(25)
                        .controlSize(.large)
                        .padding(.vertical, 14)
                })
                
                Spacer()
            }
            .padding(15)
            .padding(.vertical, 20)
        }
    }
    
    // Point View
    @ViewBuilder
    func PointView(symbol: String, title: String, subTitle: String) -> some View {
        HStack(spacing: 20) {
            Image(systemName: symbol)
                .frame(width: 45)
                .font(.largeTitle)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subTitle)
                    .foregroundStyle(.black)
                    .minimumScaleFactor(0.6)
            }
        }
    }
}

#Preview {
    OnboardScreen()
}
