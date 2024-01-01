//
//  EmptyRecipeState.swift
//  Ritual
//
//  Created by Tyler Rhodes on 6/19/23.
//

import SwiftUI

struct EmptyRecipeState: View {
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack(alignment: .center,spacing: 12) {
                    Text("Haven't found a favorite recipe yet?")
                        .font(.title3).bold()
                    Text("You gotta start somewhere.")
                        .font(.footnote)
                }
                NavigationLink(destination: BrewView()) {
                    HStack {
                        Text("Create your first recipe")
                            .foregroundColor(.black)
                        Symbols.arrow
                            .foregroundColor(.black)
                    }
                    .font(.headline).bold()
                }
            }
            .frame(width: 360, height: 180, alignment: .center)
            .multilineTextAlignment(.center)
        }
    }
}

struct EmptyRecipeState_Previews: PreviewProvider {
    static var previews: some View {
        EmptyRecipeState()
    }
}
