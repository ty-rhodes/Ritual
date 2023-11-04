//
//  Persistence.swift
//  Ritual
//
//  Created by Tyler Rhodes on 3/20/23.
//

import SwiftUI
import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        container = NSPersistentContainer(name: "Ritual")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load store with error: \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❗️Error saving to core data. \(error.localizedDescription)")
            }
        }
    }
}

private let EntryFormatter: DateFormatter = {
    let formatter       = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
