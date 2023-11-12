//
//  SavedEntryView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 7/18/23.
//

import SwiftUI

struct SavedEntryView: View {
    @Environment(\.dismiss) var dimiss
    
    var entry: Entry
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.entryAndRecipesBackground
                    .ignoresSafeArea()
                // MARK: - Saved Entry
                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.timeStamp?.entryDate ?? "")
                        .font(.system(size: 16, weight: .thin))
                    VStack(alignment: .leading, spacing: 40) {
                        Text(entry.entryTitle ?? "")
                            .font(.system(size: 26, weight: .light))
                            .fontWeight(.bold)
                        Text(entry.entry ?? "")
                            .font(.system(size: 20, weight: .light))
                    }
                    
                }
                .frame(width: 340, height: 600, alignment: .top)
                .multilineTextAlignment(.leading)
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            // MARK: - Saved Entry Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backToSavedEntries
                }
            }
        }
    }
}

struct SavedEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let context        = PersistenceController.shared.viewContext

        let newItem        = Entry(context: context)
        newItem.timeStamp  = Date()
        newItem.entryTitle = "This is your entry title."
        newItem.entry      = "This is a sample entry for my SavedEntryView within this application."

        return SavedEntryView(entry: newItem)
            .environment(\.managedObjectContext, context)
    }
}

//MARK: - Extensions
extension Date {
    var savedEntryDate: String {
        self.formatted(date: .numeric, time: .omitted)
    }
}

private extension SavedEntryView {
    
    var backToSavedEntries: some View {
        Button {
            dimiss()
        } label: {
            HStack {
                Symbols.back
            }
            Text("Saved Entries")
        }
        .tint(.black)
        .fontWeight(.light)
    }
}
