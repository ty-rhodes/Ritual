//
//  BrewView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 3/20/23.
//

import SwiftUI

struct BrewView: View {
    @EnvironmentObject var recipesViewModel: RecipesViewModel
//    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.method, ascending: false)], animation: .default)
    private var recipes: FetchedResults<Recipe>
    
//    @StateObject private var recipeViewModel = RecipesViewModel(viewContext: PersistenceController.shared.viewContext)
    
    let brewMethods: [String] = ["Drip", "Pour Over", "French Press", "Espresso"]
    
    @State private var selectedBrewMethod: String? = nil
    @State private var linkActivated: Bool         = false

//    @State private var recipe: Recipe?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.brewBackground
                    .ignoresSafeArea()
                ScrollView {
                    VStack( alignment: .leading, spacing: 24) {
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
//                    .padding(.vertical, DeviceTypes.isiPhoneSE ? 44 : 12)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
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
                BrewCupView() // Don't need to inject environment object since you did it already to the parent
            }
            .onAppear {
                // Need to call this to start building your recipe in progress. - Jon
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
                    BrewMethodCard(brewMethodCoffeeType: method)
                        .background(recipesViewModel.selectedBrewMethod == method ? Color.white : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .onTapGesture {
                            withAnimation {
                                recipesViewModel.selectedBrewMethod = method
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
        // You have an issue with the way you build your Next button with a NavigationLink.
        // This won't activate the link AND the the button action. Try something
        // like this instead. - Jon
//        NavigationLink(destination: BrewCupView().environmentObject(recipesViewModel)) {
//            Button("Next") {
//                // Save selected brew method
//                recipesViewModel.recipeInProgress?.method = selectedBrewMethod ?? ""
//                recipesViewModel.saveRecipe()
//            }
//            .frame(width: 350, height: 50)
//            .background(Theme.brewButton)
//            .foregroundColor(.white)
//            .font(.system(size: 16, weight: .semibold))
//            .cornerRadius(25)
//            .controlSize(.large)
//            .padding(.horizontal, 22)
//        }
        Button("Next") {
            // Save selected brew method
//            recipesViewModel.recipeInProgress?.method = selectedBrewMethod ?? ""
            recipesViewModel.recipeInProgress?.method = recipesViewModel.selectedBrewMethod
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
