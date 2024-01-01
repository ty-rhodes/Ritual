//
//  EmptyEntryState.swift
//  Ritual
//
//  Created by Tyler Rhodes on 3/28/23.
//

import SwiftUI

struct EmptyEntryState: View {
    var body: some View {
        ZStack {
            VStack(alignment: .center,spacing: 20) {
                VStack(spacing: 12) {
                    Text("You haven't made any journal entries yet.")
                        .font(.title2).bold()
                    Text("But there's a first time for everything right?")
                        .font(.footnote)
                }
                NavigationLink(destination: NewEntryView()) {
                    HStack {
                        Text("Write your first entry")
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

struct EmptyEntryState_Previews: PreviewProvider {
    static var previews: some View {
        EmptyEntryState()
    }
}
