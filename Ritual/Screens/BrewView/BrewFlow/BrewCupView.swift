//
//  BrewCupView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 5/22/23.
//

import SwiftUI

struct BrewCupView: View {
    @EnvironmentObject private var recipesViewModel: RecipesViewModel
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.cups, ascending: false)], animation: .default)
    private var recipes: FetchedResults<Recipe>
    
    @State private var linkActivated: Bool   = false
    @State private var sliderValue           = 1.0
    @State private var hapticFeedbackEnabled = true
    
    private var cups: Int {
        return Int(sliderValue)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.brewBackground
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 11) {
                        // MARK: - Cup Question
                        HStack(spacing: 58) {
                            Text("How much coffee do you want to make?")
                                    .font(.system(size: 50, weight: .light))
                                    .foregroundColor(Theme.entryAndRecipesBackground)
                                    .frame(width: 300, height: 150, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .minimumScaleFactor(0.6)
                            Text("")
                        }
                        // MARK: - Cup Slider and Button
                        numberOfCups
                        cupSlider
                        // MARK: - Next Button
                        nextButton
                    }
                    .padding(.vertical, DeviceTypes.isiPhoneSE ? 44 : 22)
                }
            }
            .navigationBarBackButtonHidden(true)
            // MARK: - Cup ToolBar
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
                BrewRatioView() 
            }
        }
    }
}

struct BrewCupView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RecipesViewModel(viewContext: PersistenceController.shared.viewContext)
        return BrewCupView()
            .environmentObject(viewModel)
    }
}

//MARK: - Extensions
private extension BrewCupView {
    
    var numberOfCups: some View {
        VStack {
            Text("\(cups)")
                .font(.system(size: 140))
                .foregroundColor(.white)
            if sliderValue == 1 {
                Text("Cup")
                    .font(.system(size: 30, weight: .light))
                    .foregroundColor(Theme.entryAndRecipesBackground)
            } else {
                Text("Cups")
                    .font(.system(size: 30, weight: .light))
                    .foregroundColor(Theme.entryAndRecipesBackground)
            }
        }
    }
    
    var cupSlider: some View {
        // Adjust the range as needed
        Slider(value: $sliderValue, in: 1...5, step: 1.0)
            .accentColor(Theme.entryAndRecipesBackground)
            .padding(.horizontal, 16)
            .accessibility(label: Text("Cup Slider"))
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
//        NavigationLink(destination: BrewRatioView().environmentObject(recipesViewModel)) {
//            Button("Next") {
//                // Save number of cups
////                recipesViewModel.saveCups(cups: cups)
//                recipesViewModel.recipeInProgress?.cups = Int32(cups)
//                recipesViewModel.saveRecipe()
//            }
//            .frame(width: 350, height: 50)
//            .background(Theme.brewButton)
//            .foregroundColor(.white)
//            .font(.system(size: 16, weight: .semibold))
//            .cornerRadius(25)
//            .controlSize(.large)
//        }
        Button("Next") {
            // Save number of cups
            recipesViewModel.recipeInProgress?.cups = Int32(cups)
//            recipesViewModel.saveRecipe()
            linkActivated = true
        }
        .frame(width: 350, height: 50)
        .background(Theme.brewButton)
        .foregroundColor(.white)
        .font(.system(size: 16, weight: .semibold))
        .cornerRadius(25)
        .controlSize(.large)
        .padding(.horizontal, 22)
        .padding(.vertical, 42)
    }
}
