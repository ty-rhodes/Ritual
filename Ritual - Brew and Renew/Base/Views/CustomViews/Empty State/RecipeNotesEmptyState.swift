//
//  RecipeNotesEmptyState.swift
//  Ritual
//
//  Created by Tyler Rhodes on 8/7/23.
//

import SwiftUI

struct RecipeNotesEmptyState: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Add a note to this tasty brew.")
                    .font(.title3).bold()
            }
            .frame(width: 340, height:150, alignment: .center)
            .minimumScaleFactor(0.6)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .overlay( RoundedRectangle(cornerRadius: 30).stroke(.white, lineWidth: 1))
            .foregroundColor(.black)
            .padding(.horizontal, 20)
        }
    }
}

struct RecipeNotesEmptyState_Previews: PreviewProvider {
    static var previews: some View {
        RecipeNotesEmptyState()
    }
}
