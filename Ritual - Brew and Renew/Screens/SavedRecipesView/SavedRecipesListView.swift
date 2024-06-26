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
    
    @FetchRequest( sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.createdAt, ascending: true)], animation: .default)
    private var recipes: FetchedResults<Recipe>
    
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
        }
    }
}

struct SavedRecipesListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedRecipesListView()
            .environmentObject(RecipesViewModel(viewContext: PersistenceController.shared.viewContext))
    }
}

private extension SavedRecipesListView {
    
    var savedRecipesList: some View {
        List {
            // List should be pointing to the @FetchRequest array in your view. 
            ForEach(recipes) { recipe in
                NavigationLink(destination: SavedRecipesView(recipe: recipe)) {
                    SavedRecipesCell(recipe: recipe)
                    Text(recipe.recipeTitle ?? "")
                }
                // MARK: - Recipe Swipe Actions
                .swipeActions(edge: .leading) {
                    NavigationLink(destination: BrewTimerView()) {
                        Button {
                            // Go to BrewTimerView
                        } label: {
                            Text("Brew")
                        }
                    }
                    .tint(Theme.brewBackground)
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    // To delete a recipe, just go through the viewContext.
                    if recipes.indices.contains(index) {
                        viewContext.delete(recipes[index])
                    }
                }
            }
        }
        .background(Theme.entryAndRecipesBackground)
        .scrollContentBackground(.hidden)
    }
}

