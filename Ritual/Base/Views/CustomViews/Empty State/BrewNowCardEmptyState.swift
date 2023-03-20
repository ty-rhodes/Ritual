//
//  BrewNowCardEmptyState.swift
//  Ritual
//
//  Created by Tyler Rhodes on 7/23/23.
//

import SwiftUI

struct BrewNowCardEmptyState: View {
    var body: some View {
        ZStack {
            VStack(spacing: 28) {
                VStack(alignment: .center,spacing: 12) {
                    Text("Haven't found a favorite recipe yet?")
                        .font(.title3).bold()
                    Text("You gotta start somewhere.")
                        .font(.caption)
                }
                NavigationLink(destination: BrewView()) {
                    HStack {
                        Text("Create your first recipe")
                            .foregroundColor(.black)
                        Symbols.arrow
                            .foregroundColor(.black)
                    }
                    .font(.title3).bold()
                }
            }
            .frame(width: 360, height: 180, alignment: .center)
            .multilineTextAlignment(.center)
            .overlay( RoundedRectangle(cornerRadius: 30)
                .stroke(.white, lineWidth: 1))
            .offset(x: 4)
        }
    }
}

struct BrewNowCardEmptyState_Previews: PreviewProvider {
    static var previews: some View {
        BrewNowCardEmptyState()
    }
}
