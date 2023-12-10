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
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.recipe, ascending: false)], animation: .default)
    private var recipes: FetchedResults<Recipe>
    
    var recipe: Recipe
    
    @State private var  notes          = ""
    @State private var  isEditingNotes = false
    
    @State private var linkActivated: Bool   = false
    @State private var hapticFeedbackEnabled = true
    
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
//                            VStack {
//                                HStack(spacing: 190) {
//                                    Text("Notes")
//                                        .font(.system(size: 26, weight: .light))
//                                        .frame(width: 80)
//                                    
//                                    if isEditingNotes {
//                                        saveNotesButton
//                                    } else {
//                                        editNotesButton
//                                    }
//                                }
//                                // MARK: - Notes View
//                                Group {
//                                    if isEditingNotes {
//                                        recipeNotesEditor
//                                    } else if notes.isEmpty  {
//                                        RecipeNotesEmptyState()
//                                    } else {
//                                        Text(recipesViewModel.recipeNotes) // Display the notes in non-edit mode
//                                            .font(.system(size: 16, weight: .light))
//                                            .frame(width: 340, height: 150, alignment: .topLeading)
//                                            .multilineTextAlignment(.leading)
//                                            .padding(.horizontal, 14)
//                                            .padding(.vertical, 10)
//                                            .overlay( RoundedRectangle(cornerRadius: 30)
//                                                .stroke(.white, lineWidth: 1))
//                                            .foregroundColor(.black)
//                                    }
//                                }
//                            }
//                            .padding()
//                            .fontWeight(.light)
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
                        }
                        .toolbarBackground(Theme.entryAndRecipesBackground, for: .navigationBar)
                        .navigationDestination(isPresented: $linkActivated) {
                            BrewTimerView()
                        }
                        .onTapGesture {
                            hideKeyboard()
                        }
//                        .onAppear {
//                            notes = recipesViewModel.fetchRecipeNotes(for: recipe)
//                        }
                    }
                }
            }
        }
    }
}

struct SavedRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        let context             = PersistenceController.shared.viewContext
        let newRecipe           = Recipe(context: context)
        newRecipe.recipeTitle   = "Morning Cup o' Joe"
        newRecipe.method        = "French Press"
        newRecipe.cups          = 6
        newRecipe.gramsOfCoffee = 1080
        newRecipe.ouncesOfWater = 36
        newRecipe.ratio         = "1:16" 
        
        return SavedRecipesView(recipe: newRecipe)
            .environment(\.managedObjectContext, context)
            .environmentObject(RecipesViewModel(viewContext: PersistenceController.shared.viewContext))
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
                if recipe.cups == 1 {
                    Text("\(recipe.cups) Cup")
                } else {
                    Text("\(recipe.cups) Cups")
                }
            }
            .font(.system(size: 14, weight: .semibold))
        }
    }
    
    var recipeDetails: some View {
        VStack(spacing: 20) {
            VStack {
                Text("\(recipe.gramsOfCoffee)")
                    .font(.system(size: 52))
                Text("grams of coffee")
                    .font(.system(size: 16))
            }
            VStack {
                Text("\(recipe.ouncesOfWater)")
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
//        NavigationLink(destination: BrewTimerView()) {
//            Text("Brew This Recipe")
//                .frame(width: 350, height: 50)
//                .background(Theme.brewButton)
//                .foregroundColor(.white)
//                .font(.system(size: 16, weight: .semibold, design: .default))
//                .cornerRadius(25)
//                .controlSize(.large)
//                .padding()
//        }
//        .padding(.horizontal, 8)
        
        Button("Brew This Recipe") {
            // Save selected ratio
            if hapticFeedbackEnabled {
                Haptics.mediumImpact()
            }
            linkActivated = true
        }
        .frame(width: 350, height: 50)
        .background(Theme.brewButton)
        .foregroundColor(.white)
        .font(.system(size: 16, weight: .semibold))
        .cornerRadius(25)
        .controlSize(.large)
        .padding()
        .padding(.horizontal, 8)
        .padding(.vertical, 40)
    }
    
    var recipeNotesEditor: some View {        
        TextField("Write your notes here...", text: $recipesViewModel.recipeNotes, axis: .vertical)
            .font(.system(size: 16, weight: .light))
            .frame(width: 340, height: 150, alignment: .topLeading)
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
            recipesViewModel.saveRecipeNotes(for: recipe, with: notes)
            notes = recipesViewModel.recipeNotes
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
