//
//  SavedRecipesCell.swift
//  Ritual
//
//  Created by Tyler Rhodes on 7/1/23.
//

import SwiftUI

struct SavedRecipesCell: View {
    @Environment(\.managedObjectContext) private var viewContext

    @StateObject var viewModel = RecipesViewModel(viewContext: PersistenceController.shared.viewContext)
    
    var recipe: Recipe
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.recipeTitle ?? "Morning cup o' Joe")
                    .font(.system(size: 16, weight: .semibold))
                HStack {
                    Text(recipe.method ?? "")
                        .font(.system(size: 16, weight: .light))
                    Text("·")
                        .font(.system(size: 16, weight: .bold))
                    if recipe.cups == 1 {
                        Text("\(recipe.cups) Cup")
                            .font(.system(size: 16, weight: .light))
                    } else {
                        Text("\(recipe.cups) Cups")
                            .font(.system(size: 16, weight: .light))
                    }
                }
            }
        }
    }
}

struct SavedRecipesCell_Previews: PreviewProvider {
    static var previews: some View {
        let context           = PersistenceController.shared.viewContext
        let newRecipe         = Recipe(context: context)
        newRecipe.recipeTitle = "Morning cup 'o Joe"
        newRecipe.method      = "French Press"
        newRecipe.cups        = 6

        return SavedRecipesCell(recipe: newRecipe)
            .environment(\.managedObjectContext, context)
    }
}
