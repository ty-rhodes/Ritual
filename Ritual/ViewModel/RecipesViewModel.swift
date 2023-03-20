//
//  RecipesViewModel.swift
//  Ritual
//
//  Created by Tyler Rhodes on 7/22/23.
//

import SwiftUI
import CoreData

final class RecipesViewModel: ObservableObject {
    
    private let viewContext: NSManagedObjectContext
        
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext // Inject the managed object context in the initializer
        fetchRecipes()
    }

    @Published var newRecipe: RecipeInput = RecipeInput()
    @Published var recipes: [Recipe]   = []
    @Published var recipeNotes: String = ""
    
    @Published var selectedBrewMethod: String = ""
//    @Published var selectedCups: Int          = 0
//    @Published var recipeRatio: String        = ""
    
    // Suggested var from Jon
    @Published var recipeInProgress: Recipe?
    
    struct RecipeInput {
        var method: String = ""
        var cups: Int = 0
        var ratio: String = ""
        var grams: Int = 0
        var ounces: Int = 0
    }
    
    
    func fetchRecipes() {
           do {
               let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
               let recipes  = try viewContext.fetch(request)
               self.recipes = recipes
           } catch {
               let nsError = error as NSError
               print("Error fetching entries: \(nsError), \(nsError.userInfo)")
           }
       }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
    }
    
    func deleteRecipe(at recipe: Recipe) {
        viewContext.delete(recipe)
        saveContext()
        // Remove the deleted recipe from the local 'recipes' array.
        recipes.removeAll { $0 == recipe }
    }
    
    func saveRecipe() {
        guard !newRecipe.method.isEmpty else { return }
        guard !newRecipe.ratio.isEmpty else { return }
        
        let recipe = Recipe(context: viewContext)
        recipe.method = newRecipe.method
        recipe.cups   = Int32(newRecipe.cups)
        recipe.grams  = Int32(newRecipe.grams)
        recipe.ounces = Int32(newRecipe.ounces)
        recipe.ratio  = newRecipe.ratio
        saveContext()
        
//        // Clear the input after Saving
//        newRecipe = RecipeInput()
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
    
    func saveRecipeNotes(for recipe: Recipe, with notes: String) {
        guard !notes.isEmpty else { return }
        recipe.notes = notes
        saveContext()
    }
    
    func saveBrewMethod(brewMethod: String) {
        guard !brewMethod.isEmpty else { return }

        let recipe    = Recipe(context: viewContext)
        recipe.method = brewMethod
        saveContext()
    }

    func saveCups(cups: Int) {
        guard !cups.isMultiple(of: 0) else { return }

        let recipe  = Recipe(context: viewContext)
        recipe.cups = Int32(cups)
        saveContext()
    }

    func saveSelectedRatio(_ ratio: String) {
        let newBrewRatio = Recipe(context: viewContext)
        newBrewRatio.ratio = ratio
        try? viewContext.save()
    }

    func fetchSelectedRatio() -> String? {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        if let result = try? viewContext.fetch(request), let brewRatio = result.first {
            return brewRatio.ratio
        }
        return nil
    }
    
    func saveContext(completion: @escaping (Error?) -> () = {_ in}) {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                fetchRecipes()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
