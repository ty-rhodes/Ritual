//
//  EntryGroup.swift
//  Ritual
//
//  Created by Tyler Rhodes on 6/19/23.
//

import Foundation

struct EntryGroup: Identifiable {
    let id = UUID()
    let date: String
    let entries: [Entry]
    
    var dateParsed: Date {
        date.dateParsed()
    }
    
    var month: String {
        dateParsed.formatted(.dateTime.year().month(.wide))
    }
}
