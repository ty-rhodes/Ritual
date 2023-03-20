//
//  Alert.swift
//  Ritual
//
//  Created by Tyler Rhodes on 8/2/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
    let actionButton: Alert.Button
}

struct AlertContext {
    // Custom Alerts
    static let unfinishedEntry = AlertItem(title: Text("Warning"),
                                           message: Text("Are you sure you want to leave without finishing your entry?"),
                                           dismissButton: .default(Text("Yes")),
                                           actionButton: .cancel(Text("Keep Typing")))
}
