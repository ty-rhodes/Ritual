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
    // When managing items in the list, go through the ManagedObjectContext. - Jon
//    @Published var recipes: [Recipe]   = []
    
    @Published var selectedBrewMethod: String = ""
    @Published var selectedCups: Int          = 0
    @Published var recipeRatio: String        = ""
    @Published var recipeOunces: Int          = 0
    @Published var recipesGrams: Int          = 0
    @Published var recipeNotes: String        = ""
    
    // Suggested var from Jon
    @Published var recipeInProgress: Recipe?
    
    func calculateCoffeeAndWater(ratio: Int) -> (gramsOfCoffee: Double, ouncesOfWater: Double) {
        // Constants
        let coffeePerOunce = 5.0 / 4.0 // 5g of coffee for every 4 ounces of water
        
        // Calculate ounces of water needed for 1 cup of coffee based on the ratio
        let ouncesOfWater = 8.0 // 1 cup is generally considered to be 8 ounces
        let gramsOfCoffee = (ouncesOfWater / Double(ratio)) * coffeePerOunce
        
        return (gramsOfCoffee, ouncesOfWater)
    }
    
    // MARK: - Recipe Methods
    func addRecipe(_ recipe: Recipe) {
        // Adding to the array does nothing. When you fetch from Core Data with NSFetchRequest, you get the array
        // of recipes. But making edits to that array doesn't modify the Core Data objects. Adding to the array
        // doesn't add it to your saved recipes. You have to go through the ManagedObjectContext to do that.
        // You can do that here like this, or just do it in the View since you have the context there as well. - Jon
//        recipes.append(recipe)
        viewContext.insert(recipe)
    }
    
    func deleteRecipe(at recipe: Recipe) {
        viewContext.delete(recipe)
        saveContext()
        // Remove the deleted recipe from the local 'recipes' array.
//        recipes.removeAll { $0 == recipe }
    }
    
//    func saveRecipe() {
//        guard !newRecipe.method.isEmpty else { return }
//        guard !newRecipe.ratio.isEmpty else { return }
//        
//        let recipe = Recipe(context: viewContext)
//        recipe.method = newRecipe.method
//        recipe.cups   = Int32(newRecipe.cups)
//        recipe.grams  = Int32(newRecipe.grams)
//        recipe.ounces = Int32(newRecipe.ounces)
//        recipe.ratio  = newRecipe.ratio
//        saveContext()
//        
//        // Clear the input after Saving
//        newRecipe = RecipeInput()
//    }

    // Use this to create your initial recipe in progress
    func startNewRecipe() {
        let newRecipe    = Recipe(context: viewContext)
        recipeInProgress = newRecipe
    }

    func createRecipe(method: String, cups: Int, ratio: String) {
        let newRecipe    = Recipe(context: viewContext)
        newRecipe.method = method
        newRecipe.cups   = Int32(cups)
        newRecipe.ratio  = ratio
        // You need to insert the new recipe to your ManagedObjectContext to save it. - Jon
        viewContext.insert(newRecipe)
        saveContext()
    }
    
    func saveRecipe() {
        // The warning on this line that Xcode gives should be your clue why this doesn't work.
        // "Value 'recipe' was defined but never used" - Jon
        guard let recipe = recipeInProgress else { return }
        viewContext.insert(recipe) // Adding this line removes the warning - Jon
        saveContext()
    }
    
//    func saveRecipe(method: String, cups: Int32, ratio: String) {
//        guard !method.isEmpty else { return }
//        guard !cups.isMultiple(of: 0) else { return }
//        guard !ratio.isEmpty else { return }
//
//        let newRecipe    = Recipe(context: viewContext)
//        newRecipe.method = method
//        newRecipe.cups   = cups
//        newRecipe.ratio  = ratio
//        saveContext()
//    }
//    
//    func saveBrewMethod(brewMethod: String) {
//        guard !brewMethod.isEmpty else { return }
//
//        let recipe    = Recipe(context: viewContext)
//        recipe.method = brewMethod
//        saveContext()
//    }
//
//    func saveCups(cups: Int) {
//        guard !cups.isMultiple(of: 0) else { return }
//
//        let recipe  = Recipe(context: viewContext)
//        recipe.cups = Int32(cups)
//        saveContext()
//    }
//
//    func saveSelectedRatio(ratio: String) {
//        let newBrewRatio = Recipe(context: viewContext)
//        newBrewRatio.ratio = ratio
//        try? viewContext.save()
//    }
//
//    func fetchSelectedRatio() -> String? {
//        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
//        if let result = try? viewContext.fetch(request), let brewRatio = result.first {
//            return brewRatio.ratio
//        }
//        return nil
//    }
    
    // MARK: - Recipe Notes Methods
    func saveRecipeNotes(for recipe: Recipe, with notes: String) {
        guard !notes.isEmpty else { return }
        recipe.notes = notes
        saveContext()
    }
    
    func fetchRecipeNotes(for recipe: Recipe) -> String {
        return recipe.notes ?? ""
    }
    
    // This isn't an async operation, so you don't need the completion handler at all.
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
