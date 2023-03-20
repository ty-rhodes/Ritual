//
//  BackButton.swift
//  Ritual
//
//  Created by Tyler Rhodes on 8/5/23.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) var dimiss
    
    var body: some View {
        Button {
            dimiss()
        } label: {
            HStack {
                Symbols.back
            }
            Text("Back")
        }
        .tint(.black)
        .fontWeight(.light)
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton()
    }
}
