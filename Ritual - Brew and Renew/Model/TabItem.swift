//
//  TabItem.swift
//  Ritual
//
//  Created by Tyler Rhodes on 6/17/23.
//

import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: Image
    var tab: Tab
}

var tabItems = [
    TabItem(text: "Home", icon: Image("home-icon"), tab: .home),
    TabItem(text: "Entries", icon: Image("journal-icon"), tab: .journalEntries),
    TabItem(text: "Recipes", icon: Image("recipes-icon"), tab: .brewRecipes),
    TabItem(text: "Settings", icon: Image("settings-icon"), tab: .settings),
    TabItem(text: "Brew", icon: Image("brew-icon"), tab: .brew)
]

enum Tab: String {
    case home
    case journalEntries
    case brewRecipes
    case settings
    case brew
}
