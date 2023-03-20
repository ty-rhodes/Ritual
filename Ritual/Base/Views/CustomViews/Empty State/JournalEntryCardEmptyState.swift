//
//  JournalEntryCardEmptyState.swift
//  Ritual
//
//  Created by Tyler Rhodes on 7/23/23.
//

import SwiftUI

struct JournalEntryCardEmptyState: View {
    var body: some View {
        ZStack {
            VStack(alignment: .center,spacing: 20) {
                VStack(spacing: 12) {
                    Text("You haven't made any journal entries yet.")
                        .font(.title2).bold()
                    Text("But there's a first time for everything right?")
                        .font(.caption)
                }
                NavigationLink(destination: NewEntryView()) {
                    HStack {
                        Text("Write your first Entry")
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

struct JournalEntryCardEmptyState_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryCardEmptyState()
    }
}
