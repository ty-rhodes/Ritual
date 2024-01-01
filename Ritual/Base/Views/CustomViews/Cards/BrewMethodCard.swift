//
//  BrewMethodCard.swift
//  Ritual
//
//  Created by Tyler Rhodes on 5/22/23.
//

import SwiftUI

struct BrewMethodCard: View {
    
    let brewMethodCoffeeType: String
    let iconName: Image
    
    var body: some View {
            VStack(alignment: .center) {
                iconName
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .fontWeight(.thin)
                
                Text(brewMethodCoffeeType)
            }
            .frame(width: 185, height: 280)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}

struct BrewMethodCard_Previews: PreviewProvider {
    static var previews: some View {
        BrewMethodCard(brewMethodCoffeeType: "French Press", iconName: Symbols.frenchPress)
    }
}
