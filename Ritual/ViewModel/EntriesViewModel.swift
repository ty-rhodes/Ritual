//
//  EntriesViewModel.swift
//  Ritual
//
//  Created by Tyler Rhodes on 6/17/23.
//

import SwiftUI
import CoreData
import Collections

typealias EntriesGroup = OrderedDictionary<String, [Entry]>

final class EntriesViewModel: ObservableObject {
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext // Inject the managed object context in the initializer
        fetchEntries()
    }
    
    @Published var newEntryTitle: String   = ""
    @Published var newEntry: String        = ""
    @Published var entries: [Entry]        = []
    
    @Published var alertItem: AlertItem?
    @Published var isShowingAlert: Bool = false
    
//    func groupEntriesByMonth() ->EntriesGroup {
//        guard !entries.isEmpty else { return [:] }
//        let groupedEntries = EntriesGroup(grouping: entries) { $0.month }
//
//        return groupedEntries
//    }
    
    func addEntry(_ entry: Entry) {
        entries.append(entry)
    }
    
    func deleteEntry(at entry: Entry) {
        withAnimation {
            viewContext.delete(entry)
            saveContext()
            // Remove the deleted entry from the local 'entries' array to reflect the change immediately in the UI.
            entries.removeAll { $0 == entry }
        }
    }
    
    func saveNewEntry(title: String, text: String) {
        guard !title.isEmpty else { return }
        guard !text.isEmpty else { return }
        
        let entry        = Entry(context: viewContext)
        entry.entryTitle = title
        entry.entry      = text
        entry.timeStamp  = Date()
        saveContext()
    }
    
    func fetchEntries() {
        do {
            let request: NSFetchRequest<Entry> = Entry.fetchRequest()
            let sortDescriptor                 = NSSortDescriptor(keyPath: \Entry.timeStamp, ascending: false)
            request.sortDescriptors            = [sortDescriptor]
            
            let entries  = try viewContext.fetch(request)
            self.entries = entries
        } catch {
            let nsError = error as NSError
            print("Error fetching entries: \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteEntries(at offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                guard entries.indices.contains(index) else {
                    print("Invalid index: \(index)")
                    return
                }
                let entry = entries[index]
                viewContext.delete(entry)
            }
            saveContext()
        }
    }
    
        
    func saveContext(completion: @escaping (Error?) -> () = {_ in}) {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
