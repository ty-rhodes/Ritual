//
//  SaveAndWriteView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 5/23/23.
//

import SwiftUI

struct SaveAndWriteView: View {
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    @State private var linkActivated: Bool   = false
    @State private var hapticFeedbackEnabled = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.homeBackground
                    .ignoresSafeArea()
                ScrollView {
                    VStack {
                        PromptView(prompts: PromptList.prompts)
                        VStack {
                            saveRecipeButton
                            writeEntryButton
                        }
                        Spacer()
                    }
                    .padding(.vertical, 80)
                    .padding(.horizontal, 35)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $linkActivated) {
                SavedRecipesListView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
                ToolbarItem(placement: .primaryAction) {
//                    NavigationLink(destination: BrewView()) {
//                        Symbols.dismiss
//                            .font(.title2)
//                            .fontWeight(.light)
//                            .foregroundColor(.black)
//                    }
                }
            }
        }
    }
}

struct SaveAndWriteView_Previews: PreviewProvider {
    static var previews: some View {
        SaveAndWriteView()
    }
}

//MARK: - Extensions
private extension SaveAndWriteView {
    
    var saveRecipeButton: some View {
        Button(action: {
            // Navigate to SavedRecipesView
            if hapticFeedbackEnabled {
                Haptics.mediumImpact()
            }
            recipesViewModel.saveRecipe()
            linkActivated = true
        }) {
            Text("Save Recipe")
        }
        .frame(width: 350, height: 60)
        .background(.clear)
        .foregroundColor(.white)
        .font(.system(size: 16, weight: .semibold, design: .default))
        .overlay( RoundedRectangle(cornerRadius: 30).stroke(Color.white, lineWidth: 2))
        .controlSize(.large)
        .padding(4)
    }
    
    var writeEntryButton: some View {
        NavigationLink(destination: NewEntryView()) {
            Text("Write Journal Entry")
                .frame(width: 350, height: 60)
                .background(Theme.journalButton)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .cornerRadius(30)
                .controlSize(.large)
                .padding(4)
        }
    }
}
