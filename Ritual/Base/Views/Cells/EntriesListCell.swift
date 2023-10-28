//
//  EntriesListCell.swift
//  Ritual
//
//  Created by Tyler Rhodes on 4/28/23.
//

import SwiftUI

struct EntriesListCell: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var viewModel = EntriesViewModel(viewContext: PersistenceController.shared.viewContext)
    
    var entry: Entry
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.entryTitle ?? "")
                    .font(.system(size: 16, weight: .light))
                    .fontWeight(.bold)
                HStack {
                    Text(entry.timeStamp?.entryDate ?? "")
                        .font(.system(size: 16, weight: .ultraLight))
                        Text(entry.entry ?? "")
                            .font(.system(size: 16, weight: .light))
                }
            }
        }
    }
}

struct EntriesListCell_Previews: PreviewProvider {
    static var previews: some View {
//        let context = PersistenceController.preview.container.viewContext
        let context = PersistenceController.shared.viewContext
        let newItem = Entry(context: context)
        newItem.timeStamp  = Date()
        newItem.entryTitle = "This is your test title."
        newItem.entry      = "This is a sample entry for my SavedEntryView within this application."

        return EntriesListCell(entry: newItem)
            .environment(\.managedObjectContext, context)
    }
}

//MARK: - Extensions
extension Date {
    var entryDate: String {
        self.formatted(date: .numeric, time: .omitted)
    }
}
