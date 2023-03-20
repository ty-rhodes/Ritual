//
//  BrewCupView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 5/22/23.
//

import SwiftUI

struct BrewCupView: View {
    @EnvironmentObject private var recipesViewModel: RecipesViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var recipeViewModel = RecipesViewModel(viewContext: PersistenceController.shared.viewContext)
    
    @State private var sliderValue = 0.5
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
                    VStack(spacing: 17) {
                        // MARK: - Cup Question
                        Text("How much coffee do you want to make?")
                            .font(.system(size: 50, weight: .light))
                            .foregroundColor(Theme.entryAndRecipesBackground)
                            .frame(width: 300, height: 150, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.6)
                        // MARK: - Cup Slider and Button
                        Spacer()
                        numberOfCups
                        Spacer()
                        cupSlider
                        Spacer()
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
                    NavigationLink(destination: BrewView()) {
                        Symbols.dismiss
                            .font(.title2)
                            .fontWeight(.light)
                            .foregroundColor(.black)
                    }
                }
            }
            .toolbarBackground(Theme.brewBackground, for: .navigationBar)
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
            Text("Cups")
                .font(.system(size: 30, weight: .light))
                .foregroundColor(Theme.entryAndRecipesBackground)
        }
    }
    
    var cupSlider: some View {
        // Adjust the range as needed
        Slider(value: $sliderValue, in: 1...6, step: 1.0)
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
//            .onChange(of: cups) { _ in
//                recipesViewModel.saveCups(cups: cups)
//            }
    }
    
    var nextButton: some View {
        NavigationLink(destination: BrewRatioView().environmentObject(recipesViewModel)) {
            Button("Next") {
                // Save number of cups
                recipeViewModel.saveRecipe()
//                recipesViewModel.saveCups(cups: cups)
            }
            .frame(width: 350, height: 50)
            .background(Color.white)
            .foregroundColor(.black)
            .font(.system(size: 16, weight: .semibold))
            .cornerRadius(25)
            .controlSize(.large)
        }
        .padding(.vertical, 54)
    }
}
