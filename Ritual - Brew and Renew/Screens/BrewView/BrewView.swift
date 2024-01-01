//
//  BrewView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 3/20/23.
//

import SwiftUI

struct BrewView: View {
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    let brewMethods: [String] = ["Drip", "Pour Over", "French Press", "Espresso"]
    
    let brewMethodIcons: [String: Image] = [
        "Drip": Symbols.mug,
        "Pour Over": Symbols.pourOver,
        "French Press": Symbols.frenchPress,
        "Espresso": Symbols.espresso
    ]
    
    @State private var linkActivated: Bool   = false
    @State private var hapticFeedbackEnabled = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.brewBackground
                    .ignoresSafeArea()
                ScrollView {
                    VStack( alignment: .leading, spacing: 18) {
                        Spacer()
                        // MARK: - Brew Question
                        Text("What method are you using to brew?")
                            .font(.system(size: 50, weight: .light))
                            .foregroundColor(Theme.entryAndRecipesBackground)
                            .frame(width: 300, height: 150, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.6)
                            .padding(.leading, 14)
                        // MARK: - Method ScrollView and Button
                        selectedMethodScrollView
                        // MARK: - Next Button
                        nextButton
                        Spacer()
                    }
                    .padding(.vertical, -30)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
//                    NavigationLink(destination: HomeView()) {
                        Button(action: {
//                            recipesViewModel.recipeInProgress?.method = nil
                        }, label: {
//                            Symbols.dismiss
//                                .font(.title2)
//                                .fontWeight(.light)
//                                .foregroundColor(.black)
                        })
//                        Symbols.dismiss
//                            .font(.title2)
//                            .fontWeight(.light)
//                            .foregroundColor(.black)
//                    }
                }
            }
            .toolbarBackground(Theme.brewBackground, for: .navigationBar)
            .navigationDestination(isPresented: $linkActivated) {
                BrewCupView()
            }
            .onAppear {
                // Need to call this to start building your recipe in progress.
                recipesViewModel.startNewRecipe()
            }
        }
    }
}

struct BrewView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RecipesViewModel(viewContext: PersistenceController.shared.viewContext)
        return BrewView()
            .environmentObject(viewModel)
    }
}

//MARK: - Extensions
private extension BrewView {
    
    var selectedMethodScrollView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 30) {
                ForEach(brewMethods, id: \.self) { method in
                    let iconName = brewMethodIcons[method] ?? Symbols.mug
                    BrewMethodCard(brewMethodCoffeeType: method, iconName: iconName)
                        .background(recipesViewModel.selectedBrewMethod == method ? Color.white : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .onTapGesture {
                            withAnimation {
                                recipesViewModel.selectedBrewMethod = method
                            }
                            if hapticFeedbackEnabled {
                                Haptics.mediumImpact()
                            }
                        }
                        .frame(width: 130, height: 300)
                        .padding(.horizontal, 18)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    var nextButton: some View {
//        NavigationLink(destination: BrewCupView().environmentObject(recipesViewModel)) {
//            Button("Next") {
//                // Save selected brew method
//                recipesViewModel.recipeInProgress?.method = selectedBrewMethod ?? ""
//                recipesViewModel.saveRecipe()
//            }
//        }
        Button("Next") {
            // Save selected brew method
            if hapticFeedbackEnabled {
                Haptics.mediumImpact()
            }
            recipesViewModel.recipeInProgress?.method = recipesViewModel.selectedBrewMethod
//            recipesViewModel.saveRecipe()
            linkActivated = true
            recipesViewModel.selectedBrewMethod = ""
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
