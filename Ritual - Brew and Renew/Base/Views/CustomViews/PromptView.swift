//
//  PromptView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 4/21/23.
//

import SwiftUI

struct PromptView: View {
    let prompts: [Prompt]
    @State private var randomIndex: Int = 0

    var body: some View {
        Text(prompts[randomIndex].promptDescription)
            .font(.system(size: 40, weight: .light))
            .frame(width: 360, height: 400)
            .padding(.horizontal)
            .minimumScaleFactor(0.6)
            .multilineTextAlignment(.center)
            .padding()
            .onAppear {
                // Generate a random index when the view appears
                randomIndex = Int.random(in: 0..<prompts.count)
            }
    }
}


struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        PromptView(prompts: PromptList.prompts)
    }
}
