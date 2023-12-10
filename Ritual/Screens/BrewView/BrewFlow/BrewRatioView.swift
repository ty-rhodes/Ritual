//
//  BrewRatioView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 5/22/23.
//

import SwiftUI

struct BrewRatioView: View {
    @EnvironmentObject private var recipesViewModel: RecipesViewModel
    
    @State private var linkActivated: Bool   = false
    @State private var sliderValue           = 0.5
    @State private var hapticFeedbackEnabled = true
    
    private var ratioValue: Int {
        let minRatio        = 12
        let maxRatio        = 20
        let valueRange      = Double(maxRatio - minRatio)
        let calculatedValue = Int(sliderValue * valueRange) + minRatio
        return calculatedValue
    }
    
    private var ratio: String {
        return "1:\(ratioValue)"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.brewBackground
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 13) {
                        // MARK: - Ratio Question
                        HStack(spacing: 58) {
                            Text("How strong do you like it?")
                                .font(.system(size: 50, weight: .light))
                                .foregroundColor(Theme.entryAndRecipesBackground)
                                .frame(width: 300, height: 140, alignment: .leading)
                                .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.6)
                            Text("")
                        }
                        Spacer()
                        // MARK: - Recommended Label
                        recommendedLabel
                        // MARK: - Ratio Slider
                        selectedRatio
                        ratioSlider
                        Spacer()
                        // MARK: - Next Button
                        nextButton
                        Spacer()
                    }
                    .padding(.vertical, 30)
                }
            }
            .navigationBarBackButtonHidden(true)
            // MARK: - Ratio Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: HomeView()) {
                        Symbols.dismiss
                            .font(.title2)
                            .fontWeight(.light)
                            .foregroundColor(.black)
                    }
                }
            }
            .toolbarBackground(Theme.brewBackground, for: .navigationBar)
            .navigationDestination(isPresented: $linkActivated) {
                BrewRecipeView()
            }
        }
    }
}

struct BrewRatioView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RecipesViewModel(viewContext: PersistenceController.shared.viewContext)
        return BrewRatioView()
            .environmentObject(viewModel)
    }
}

//MARK: - Extensions
private extension BrewRatioView {
    
    var recommendedLabel: some View {
        let ratioValue = Int(sliderValue * 8) + 12
        let label: String
        
        switch ratioValue {
        case 12...13:
            label = "Strong"
        case 14...15:
            label = "Stronger"
        case 16:
            label = "Recommended"
        case 17...18:
            label = "Weaker"
        case 19...20:
            label = "Weak"
        default:
            label = "Recommended"
        }
        
        return Text(label)
            .font(.system(size: 16, weight: .semibold))
            .frame(width: 140, height: 6)
            .foregroundColor(Theme.entryAndRecipesBackground)
    }
    
    var selectedRatio: some View {
        VStack {
            Text(ratio)
                .font(.system(size: 120))
                .foregroundColor(.white)
            Text("Ratio")
                .font(.system(size: 30, weight: .thin))
                .foregroundColor(Theme.entryAndRecipesBackground)
        }
    }
    
    var ratioSlider: some View {
        Slider(value: $sliderValue, in: 0...1, step: 0.10)
            .accentColor(Theme.entryAndRecipesBackground)
            .padding(.horizontal, 16)
            .accessibility(label: Text("Strength Slider"))
            .onAppear {
                Haptics.mediumImpact()
            }
            .onChange(of: sliderValue) { value in
                if hapticFeedbackEnabled {
                    Haptics.lightImpact()
                }
            }
    }
    
    var nextButton: some View {
        Button("Next") {
            // Save selected ratio
            if hapticFeedbackEnabled {
                Haptics.mediumImpact()
            }
            recipesViewModel.recipeInProgress?.ratio = ratio
            recipesViewModel.saveRecipe()
            linkActivated = true
        }
        .frame(width: 350, height: 50)
        .background(Theme.brewButton)
        .foregroundColor(.white)
        .font(.system(size: 16, weight: .semibold))
        .cornerRadius(25)
        .controlSize(.large)
        .padding(.horizontal, 22)
    }
}
