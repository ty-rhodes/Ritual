//
//  RecipesViewModel.swift
//  Ritual
//
//  Created by Tyler Rhodes on 7/22/23.
//

import SwiftUI
import CoreData

@MainActor
final class RecipesViewModel: ObservableObject {

    private let viewContext: NSManagedObjectContext
        
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    // Don't have a separate array of recipes here. Only use the @FetchRequest marked array in the View.
    // When managing items in the list, go through the ManagedObjectContext.
//    @Published var recipes: [Recipe]   = []
    
    @Published var selectedBrewMethod: String = ""
    @Published var selectedCups: Int          = 0
    @Published var recipeRatio: String        = ""
    @Published var recipeOunces: Int          = 0
    @Published var recipesGrams: Int          = 0
    @Published var recipeNotes: String        = ""
    
    // Suggested var from Jon
    @Published var recipeInProgress: Recipe?
    
    var gramsOfCoffee: Int {
           guard let ratio = recipeInProgress?.ratio, let cups = recipeInProgress?.cups else {
               return 0
           }
           return calculateCoffeeAndWater(ratio: ratio, cups: Int(cups)).gramsOfCoffee
       }

       var ouncesOfWater: Int {
           guard let ratio = recipeInProgress?.ratio, let cups = recipeInProgress?.cups else {
               return 0
           }
           return calculateCoffeeAndWater(ratio: ratio, cups: Int(cups)).ouncesOfWater
       }
    
    // MARK: - Calculate Coffee and Water
    func calculateCoffeeAndWater(ratio: String, cups: Int) -> (gramsOfCoffee: Int, ouncesOfWater: Int) {
        let parts = ratio.components(separatedBy: ":")
        guard parts.count == 2, let coffeePart = Int(parts[0]), let waterPart = Int(parts[1]) else {
            return (0, 0)
        }
        
        // Calculate grams of coffee based on the ratio and cups
        let gramsOfCoffee = coffeePart * cups * 24 // 24 grams per cup
        
        // Calculate ounces of water based on the ratio and cups, with 1 cup equaling 12 ounces of water
        let ouncesOfWater = (waterPart * cups * 22) / 28 // 12 ounces per cup
        
        return (gramsOfCoffee, ouncesOfWater)
    }
    
    // MARK: - Recipe Methods
//    func deleteRecipe(at recipe: Recipe) {
//        viewContext.delete(recipe)
//        saveContext()
//        // Remove the deleted recipe from the local 'recipes' array.
////        recipes.removeAll { $0 == recipe }
//    }

    // Use this to create your initial recipe in progress
    func startNewRecipe() {
        let newRecipe    = Recipe(context: viewContext)
        recipeInProgress = newRecipe
    }
    
    func saveRecipe() {
        // The warning on this line that Xcode gives should be your clue why this doesn't work.
        // "Value 'recipe' was defined but never used"
        guard let recipe = recipeInProgress else { return }
        viewContext.insert(recipe) // Adding this line removes the warning 
        saveContext()
    }
    
    // MARK: - Recipe Notes Methods
    func saveRecipeNotes(for recipe: Recipe, with notes: String) {
        guard !notes.isEmpty else { return }
        recipe.notes = notes
        saveContext()
    }
    
    func fetchRecipeNotes(for recipe: Recipe) -> String {
        return recipe.notes ?? ""
    }
    
    // MARK: - Save Context
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("❗️Error saving to core data. \(error.localizedDescription)")
            }
        }
    }
}
