//
//  JournalEntryCard.swift
//  Ritual
//
//  Created by Tyler Rhodes on 4/2/23.
//

import SwiftUI

struct JournalEntryCard: View {
//    @StateObject var viewModel = EntriesViewModel(viewContext: PersistenceController.shared.container.viewContext)
    @StateObject var viewModel = EntriesViewModel(viewContext: PersistenceController.shared.viewContext)
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let entryDate: String
    let entryTitle: String
    let entry: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 14) {
            Text(entryDate)
//                .font(.system(size: 16, weight: .light))
                .font(.subheadline)
                .fontWeight(.ultraLight)
                .foregroundColor(.black)
                .frame(width: 120, height: 10, alignment: .center)
            Text(entryTitle)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .minimumScaleFactor(0.6)
                .frame(width: 120, height: 40, alignment: .center)
            Text(entry)
                .font(.footnote)
                .fontWeight(.light)
                .foregroundColor(.black)
                .lineLimit(4)
                .truncationMode(.tail)
                .frame(width: 100, height: 40, alignment: .center)
            
                HStack {
                    Text("View Entry")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                    Symbols.arrow
                        .foregroundColor(.black)
                }
        }
        .frame(width: 130, height: 180)
        .multilineTextAlignment(.leading)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct JournalEntryCard_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryCard(entryDate: "February 12, 2023",
                         entryTitle: "Here's my first cup of coffee! ",
                         entry: "Started my morning with a nice cup of coffee")
    }
}
