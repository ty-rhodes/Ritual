//
//  BrewNowCard.swift
//  Ritual
//
//  Created by Tyler Rhodes on 4/2/23.
//

import SwiftUI

struct BrewNowCard: View {
    
    let brewNowCoffeeType: String
    let brewNowCupAmount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(brewNowCoffeeType)
                .font(.title3)
                .foregroundColor(.black)
                .bold()
                .frame(width: 100, height: 80, alignment: .leading)
            
            Text("\(brewNowCupAmount) Cups")
                .font(.subheadline)
                .foregroundColor(.black)
                .frame(width: 100, height: 20, alignment: .leading)
            
            HStack {
                Text("Brew Now")
                    .foregroundColor(.black)
                Symbols.arrow
                    .foregroundColor(.black)
            }
            .controlSize(.large)
        }
        .frame(width: 130, height: 180)
        .multilineTextAlignment(.center)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct BrewNowCard_Previews: PreviewProvider {
    static var previews: some View {
        BrewNowCard(brewNowCoffeeType: "Morning French Press", brewNowCupAmount: 6)
    }
}
