//
//  SavedRecipesView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 7/9/23.
//

import SwiftUI
import CoreData

struct SavedRecipesView: View {
    @Environment(\.dismiss) var dimiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: RecipesViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.recipe,
                                           ascending: false)],
                                           animation: .default)
    
    private var recipes: FetchedResults<Recipe>
    
    var recipe: Recipe
    
//    @ObservedObject private var viewModel = RecipesViewModel(viewContext: PersistenceController.shared.viewContext)
    
    @State private var  notes = ""
    @State private var  isEditingNotes = false
    
    @State private var scrollOffset: CGFloat  = 0
    @State private var contentHeight: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.entryAndRecipesBackground
                    .ignoresSafeArea()
                GeometryReader { geometry in
                    let tabBarHeight: CGFloat = 50
                    ScrollView {
                        VStack(spacing: 4) {
                            // MARK: - Recipe Title and Details
                            VStack(spacing: 30) {
                                recipeImageAndTitle
                                recipeDetails
                            }
                            
                            // MARK: - Recipe Notes
                            VStack {
                                HStack(spacing: 200) {
                                    Text("Notes")
                                        .font(.system(size: 26, weight: .light))
                                    
                                    if isEditingNotes {
                                        saveNotesButton
                                    } else {
                                        editNotesButton
                                    }
                                }
                                // MARK: - Notes View
                                Group {
                                    if isEditingNotes {
                                        recipeNotesEditor
                                    } else if notes.isEmpty  {
                                        RecipeNotesEmptyState()
                                    } else {
                                        Text(notes) // Display the notes in non-edit mode
                                            .font(.system(size: 16, weight: .light))
                                            .frame(width: 350, height: 150, alignment: .topLeading)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                            .overlay( RoundedRectangle(cornerRadius: 30)
                                                .stroke(.white, lineWidth: 1))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            .padding()
                            .fontWeight(.light)
                            // MARK: - Brew Recipe Button
                            brewRecipeButton
                        }
                        .frame(width: geometry.size.width)
                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                            self.scrollOffset = value
                        }
                        .padding(.bottom, scrollOffset > 0 ? 0 : tabBarHeight)
                        .padding(.top, scrollOffset > 0 ? -scrollOffset : 0)
                        .edgesIgnoringSafeArea(.bottom)
                        .padding(.vertical, 10)
                        .navigationBarBackButtonHidden(true)
                        // MARK: - Recipe Toolbar
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                backToSavedRecipes
                            }
//                            ToolbarItem(placement: .primaryAction) {
//                                Button {
//                                    // Toggle to save or unsave recipe
//                                } label: {
//                                    Symbols.heart
//                                        .font(.title2)
//                                        .foregroundColor(Color(.label))
//                                }
//                            }
                        }
                        .toolbarBackground(Theme.entryAndRecipesBackground, for: .navigationBar)
                        .onTapGesture {
                            hideKeyboard()
                        }
                        .onAppear {
                            notes = viewModel.fetchRecipeNotes(for: recipe)
                        }
                    }
                }
            }
        }
    }
}

struct SavedRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        let context            = PersistenceController.shared.viewContext
        let newRecipe          = Recipe(context: context)
        newRecipe.recipeTitle  = "Morning Cup o' Joe"
        newRecipe.method       = "French Press"
        newRecipe.cups         = 6
        newRecipe.grams        = 1080
        newRecipe.ounces       = 36
        newRecipe.ratio        = "1:16"
        
        return SavedRecipesView(recipe: newRecipe)
            .environment(\.managedObjectContext, context)
    }
}

//MARK: - Extensions
private extension SavedRecipesView {
    
    var recipeImageAndTitle: some View {
        VStack(spacing: 4) {
            Text(recipe.recipeTitle ?? "Morning Cup o' Joe")
                .font(.system(size: 36, weight: .light))
                .frame(width: 380, height: 38, alignment: .center)
                .minimumScaleFactor(0.6)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .padding(8)
            HStack {
                Text(recipe.method ?? "N/A")
                Divider()
                    .frame(height: 20)
                    .background(Color.black)
                Text("\(recipe.cups) Cups")
            }
            .font(.system(size: 14, weight: .semibold))
        }
    }
    
    var recipeDetails: some View {
        VStack(spacing: 20) {
            VStack {
                Text("\(recipe.grams)")
                    .font(.system(size: 52))
                Text("grams of coffee")
                    .font(.system(size: 16))
            }
            VStack {
                Text("\(recipe.ounces)")
                    .font(.system(size: 52))
                Text("ounces of water")
                    .font(.system(size: 16))
            }
            VStack {
                Text(recipe.ratio ?? "N/A")
                    .font(.system(size: 52))
                Text("ratio")
                    .font(.system(size: 16))
            }
            VStack {
                Text("3 min")
                    .font(.system(size: 52))
                Text("brew time")
                    .font(.system(size: 16))
            }
        }
    }
    
    
    var brewRecipeButton: some View {
        NavigationLink(destination: BrewTimerView()) {
            Text("Brew This Recipe")
                .frame(width: 350, height: 50)
                .background(Theme.brewButton)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .cornerRadius(25)
                .controlSize(.large)
                .padding()
        }
        .padding(.horizontal, 8)
    }
    
    var recipeNotesEditor: some View {        
        TextField("Write your notes here...", text: $viewModel.recipeNotes, axis: .vertical)
            .font(.system(size: 16, weight: .light))
            .frame(width: 350, height: 150, alignment: .topLeading)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .overlay( RoundedRectangle(cornerRadius: 30).stroke(.white, lineWidth: 1))
            .foregroundColor(.black)
            .padding(.horizontal, 20)
            .accessibilityHint(Text("This Textfield is for any notes you want to make for your coffee recipe."))
    }
    
    var editNotesButton: some View {
        Button(action: {
            // Enable edit mode
            isEditingNotes = true
        }) {
            Text("Edit")
        }
        .frame(width: 80, height: 28)
        .background(.clear)
        .font(.system(size: 14, weight: .semibold))
        .overlay( RoundedRectangle(cornerRadius: 25)
        .stroke(lineWidth: 1))
        .controlSize(.large)
        .foregroundColor(.black)
    }
    
    var saveNotesButton: some View {
        Button(action: {
            // Save notes
            viewModel.saveRecipeNotes(for: recipe, with: notes)
            notes = viewModel.recipeNotes
            isEditingNotes = false
        }) {
            Text("Save")
        }
        .frame(width: 80, height: 28)
        .background(.clear)
        .font(.system(size: 14, weight: .semibold))
        .overlay( RoundedRectangle(cornerRadius: 25)
        .stroke(lineWidth: 1))
        .controlSize(.large)
        .foregroundColor(.black)
    }
    
    var backToSavedRecipes: some View {
        Button {
            dimiss()
        } label: {
            HStack {
                Symbols.back
            }
            Text("Saved Recipes")
        }
        .tint(.black)
        .fontWeight(.light)
    }
}
