//
//  BrewRecipeView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 5/22/23.
//

import SwiftUI

struct BrewRecipeView: View {
    @EnvironmentObject private var recipesViewModel: RecipesViewModel
    
    @State private var recipe: Recipe?
    @State private var linkActivated: Bool   = false
    @State private var hapticFeedbackEnabled = true
    @State private var heartIconColor: Color = .black
    @State private var isHeartIconScaledUp   = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.brewBackground
                    .ignoresSafeArea()
                ScrollView {
                    // MARK: - Recipe Details
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Your Recipe")
                            .font(.system(size: 50, weight: .light))
                            .foregroundColor(Theme.entryAndRecipesBackground)
                            .frame(width: 300, height: 100, alignment: .leading)
                            .minimumScaleFactor(0.6)
                            .padding(.leading, 20)
                        // MARK: - Recipe Grid
                        VStack(alignment: .center, spacing: 10) {
                            HStack(spacing: 30) {
                                // MARK: - Grams of Coffee
                                VStack {
                                    Text("\(recipesViewModel.gramsOfCoffee)")
                                        .font(.system(size: 60))
                                    Text("grams of coffee")
                                        .font(.system(size: 24))
                                        .foregroundColor(Theme.entryAndRecipesBackground)
                                }
                                // MARK: - Ounces of Water
                                VStack {
                                    Text("\(recipesViewModel.ouncesOfWater)")
                                        .font(.system(size: 60))
                                    Text("ounces of water")
                                        .font(.system(size: 24))
                                        .foregroundColor(Theme.entryAndRecipesBackground)
                                }
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 70) {
                                // MARK: - Coffee Ratio
                                VStack {
                                    Text(recipesViewModel.recipeInProgress?.ratio ?? "N/A")
                                        .font(.system(size: 64))
                                    Text("ratio")
                                        .font(.system(size: 24))
                                        .foregroundColor(Theme.entryAndRecipesBackground)
                                }
                                .padding(.leading, 24)
                                // MARK: - Brew Time
                                VStack {
                                    Text("3 min")
                                        .font(.system(size: 60))
                                    Text("brew time")
                                        .font(.system(size: 24))
                                        .foregroundColor(Theme.entryAndRecipesBackground)
                                }
                            }
                        }
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        // MARK: - Brew Button
                        Spacer()
                        brewCoffeeButton
                        Spacer()
                    }
                    .minimumScaleFactor(0.6)
                    .padding(.vertical, DeviceTypes.isiPhoneSE ? 40 : 30)
                }
            }
            .navigationBarBackButtonHidden(true)
            // MARK: - Recipe Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        saveRecipeButton
                        NavigationLink(destination: HomeView()) {
                            Symbols.dismiss
                                .font(.title2)
                                .fontWeight(.light)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .toolbarBackground(Theme.brewBackground, for: .navigationBar)
            .navigationDestination(isPresented: $linkActivated) {
                BrewTimerView() // Don't need to inject environment object since you did it already to the parent
            }
        }
    }
}


struct BrewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let context             = PersistenceController.shared.viewContext
        let newRecipe           = Recipe(context: context)
        newRecipe.recipeTitle   = "Morning Cup o' Joe"
        newRecipe.gramsOfCoffee = 1080
        newRecipe.ouncesOfWater = 36
        newRecipe.ratio         = "1:16"
        
        return BrewRecipeView()
            .environmentObject(RecipesViewModel(viewContext: PersistenceController.shared.viewContext))
    }}

//MARK: - Extensions
private extension BrewRecipeView {
    
    var brewCoffeeButton: some View {
//        NavigationLink(destination: BrewTimerView()) {
//            Text("Brew Coffee")
//                .frame(width: 350, height: 50)
//                .background(Theme.journalButton)
//                .foregroundColor(.white)
//                .font(.system(size: 16, weight: .semibold, design: .default))
//                .cornerRadius(25)
//                .controlSize(.large)
//                .padding()
//        }
//        .padding(.horizontal, 8)
//        .padding(.vertical, 50)
        Button("Brew Coffee") {
            // Go to BrewTimerView()
            if hapticFeedbackEnabled {
                Haptics.mediumImpact()
            }
            linkActivated = true
        }
        .frame(width: 350, height: 50)
        .background(Theme.journalButton)
        .foregroundColor(.white)
        .font(.system(size: 16, weight: .semibold))
        .cornerRadius(25)
        .controlSize(.large)
        .padding()
        .padding(.horizontal, 8)
        .padding(.vertical, 50)
    }
    
    var saveRecipeButton: some View {
        Button {
            if hapticFeedbackEnabled {
                Haptics.successNotification()
            }
            recipesViewModel.recipeInProgress = recipe
            recipesViewModel.saveRecipe()
            // Change the icon color for one second and then revert it back to clear
            withAnimation {
                heartIconColor = Theme.brewButton
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    heartIconColor = .black
                }
            }
            withAnimation(.easeInOut(duration: 0.5)) {
                            isHeartIconScaledUp = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isHeartIconScaledUp = false
                            }
                        }
        } label: {
            Symbols.heart
                .font(.title3)
                .fontWeight(.light)
                .foregroundStyle(heartIconColor)
                .scaleEffect(isHeartIconScaledUp ? 1.5 : 1.0)
        }
    }
}
