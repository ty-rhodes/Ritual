//
//  BrewView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 3/20/23.
//

import SwiftUI

struct BrewView: View {
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
        @StateObject private var recipeViewModel = RecipesViewModel(viewContext: PersistenceController.shared.viewContext)
    
    let brewMethods: [String] = ["Drip", "Pour Over", "French Press", "Espresso"]
    
    @State private var selectedBrewMethod: String? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.brewBackground
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer()
                        // MARK: - Brew Question
                        Text("What method are you using to brew?")
                            .font(.system(size: 50, weight: .light))
                            .foregroundColor(Theme.entryAndRecipesBackground)
                            .frame(width: 300, height: 150, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.6)
                        // MARK: - Method ScrollView and Button
                        selectedMethodScrollView
                        Spacer()
                        // MARK: - Next Button
                        nextButton
                        Spacer()
                    }
                    .padding(.vertical, DeviceTypes.isiPhoneSE ? 44 : 22)
                }
            }
            .navigationBarBackButtonHidden(true)
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
                        .background(recipeViewModel.selectedBrewMethod == method ? Color.white : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .onTapGesture {
                            withAnimation {
                                recipeViewModel.selectedBrewMethod = method
                            }
                        }
                        .frame(width: 130, height: 340)
                        .padding(.horizontal, 18)
                }
            }
            .padding(.horizontal)
        }
    }
    
    var nextButton: some View {
        NavigationLink(destination: BrewCupView().environmentObject(recipesViewModel)) {
            Button("Next") {
                // Save selected brew method
                recipesViewModel.saveBrewMethod(brewMethod: recipesViewModel.selectedBrewMethod)
//                recipeViewModel.saveRecipe()
            }
            .frame(width: 350, height: 50)
            .background(Color.white)
            .foregroundColor(.black)
            .font(.system(size: 16, weight: .semibold))
            .cornerRadius(25)
            .controlSize(.large)
        }
    }
}
