//
//  SavedRecipesListView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 3/21/23.
//

import SwiftUI
import CoreData

struct SavedRecipesListView: View {
    
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.recipe,
                                           ascending: false)],
                                           animation: .default)
    
    private var recipes: FetchedResults<Recipe>
    
    @StateObject private var viewModel = RecipesViewModel(viewContext: PersistenceController.shared.viewContext)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.entryAndRecipesBackground
                    .ignoresSafeArea()
                VStack {
                    if recipes.isEmpty {
                        EmptyRecipeState()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // MARK: - Saved Recipes List
                        savedRecipesList
                    }
                }
                .padding(.bottom, 50)
                .padding(.top, 4)
            }
            .navigationTitle("Saved Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            // MARK: - Saved Recipes List Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
            }
            .toolbarBackground(Theme.entryAndRecipesBackground, for: .navigationBar)
            .onAppear {
                viewModel.fetchRecipes()
            }
        }
    }
}

struct SavedRecipesListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedRecipesListView()
    }
}

private extension SavedRecipesListView {
    
    var savedRecipesList: some View {
        List {
            ForEach(recipes) { recipe in
                NavigationLink(destination: SavedRecipesView(recipe: recipe)) {
                    SavedRecipesCell(recipe: recipe)
                    Text(recipe.recipeTitle ?? "")
                }
                // MARK: - Recipe Swipe Actions
                .swipeActions(edge: .leading) {
                    NavigationLink(destination: BrewTimerView()) {
                        Button {
                            // Brew method
                        } label: {
                            Text("Brew")
                        }
                    }
                    .tint(Theme.brewBackground)
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    if viewModel.recipes.indices.contains(index) {
                        viewModel.deleteRecipe(at: viewModel.recipes[index])
                    }
                }
            }
        }
        .background(Theme.entryAndRecipesBackground)
        .scrollContentBackground(.hidden)
    }
}

