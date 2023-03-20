//
//  RitualApp.swift
//  Ritual
//
//  Created by Tyler Rhodes on 3/20/23.
//

import SwiftUI

@main
struct RitualApp: App {
    
    @StateObject var recipesViewModel = RecipesViewModel(viewContext: PersistenceController.shared.container.viewContext)
    
//    var recipesViewModel: RecipesViewModel
//
//    init() {
//        recipesViewModel = RecipesViewModel(viewContext: persistenceController)
//    }

    var body: some Scene {
        WindowGroup {
//            TabBar()
            AppContainerView()
                .environment(\.managedObjectContext, PersistenceController.shared.viewContext)
                .environmentObject(recipesViewModel)
                .preferredColorScheme(.light)
        }
    }
}
