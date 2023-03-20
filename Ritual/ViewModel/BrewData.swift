//
//  BrewData.swift
//  Ritual
//
//  Created by Tyler Rhodes on 8/10/23.
//

import SwiftUI

class BrewData: ObservableObject {
    
    @Published var savedRecipes: [Recipe] = []
}
