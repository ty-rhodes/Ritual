//
//  Constants.swift
//  Ritual
//
//  Created by Tyler Rhodes on 8/10/23.
//

import SwiftUI

enum Symbols {
    static let tripleDot   = Image(systemName: "ellipsis")
    static let arrow       = Image(systemName: "arrow.right")
    static let emptyEntry  = Image(systemName: "text.book.closed")
    static let emptyRecipe = Image(systemName: "cup.and.saucer")
    static let mug         = Image(systemName: "mug")
    static let heart       = Image(systemName: "heart")
    static let dismiss     = Image(systemName: "multiply")
    static let addEntry    = Image(systemName: "plus")
    static let back        = Image(systemName: "chevron.left")
    static let link        = Image(systemName: "link")
}

enum Theme {
    static let background                = Color("background")
    static let entryAndRecipesBackground = Color("entryandrecipesbackground")
    static let brewBackground            = Color("brewbackground")
    static let brewButton                = Color("brewbutton")
    static let journalButton             = Color("journalbutton")
    static let homeBackground            = Image("homebackground")
}

enum Animations {
    static let progress = "progress-bar"
    static let welcome  = "welcome-screen"
}

// The enums below adjust our app to properly fit the screen size for each device.
enum ScreenSize {
    static let width       = UIScreen.main.bounds.size.width
    static let height      = UIScreen.main.bounds.size.height
    static let maxLength   = max(ScreenSize.width, ScreenSize.height)
    static let minLength   = min(ScreenSize.width, ScreenSize.height)
    }

enum DeviceTypes {
    static let idiom       = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale       = UIScreen.main.scale
    
    static let isiPhoneSE  = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPad      = idiom == .phone && ScreenSize.maxLength == 1024.0
}
