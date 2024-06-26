//
//  EntriesListView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 3/21/23.
//

import SwiftUI
import CoreData

enum Sort {
    case ascending, descending
}

struct EntriesListView: View {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entry.timeStamp, ascending: false)], animation: .default)
    private var entries: FetchedResults<Entry>

    @StateObject private var viewModel = EntriesViewModel(viewContext: PersistenceController.shared.viewContext)
    
    @State private var sort: Sort = .descending
    
//    @State private var searchText = ""
    
    @State private var scrollOffset: CGFloat  = 0
    @State private var contentHeight: CGFloat = 0
    
//    var filteredEntries: [Entry] {
//        guard !searchText.isEmpty else { return viewModel.entries }
//        return entries.filter { $0.entry!.localizedCaseInsensitiveContains(searchText) }
//    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.entryAndRecipesBackground
                    .ignoresSafeArea()
                // MARK: - Entries List
                    VStack {
                        if viewModel.entries.isEmpty {
                            EmptyEntryState()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            List {
                                ForEach(entries) { entry in
                                    NavigationLink (destination: SavedEntryView(entry: entry)) {
                                        EntriesListCell(entry: entry)
                                    }
                                    .listStyle(.inset)
                                }
                                .onDelete { indexSet in
                                    indexSet.forEach { index in
                                        if entries.indices.contains(index) {
                                            viewModel.deleteEntry(at: viewModel.entries[index])
                                        }
                                    }
                                }
                            }
                            .background(Theme.entryAndRecipesBackground)
                            .scrollContentBackground(.hidden)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .truncationMode(.tail)
//                            .searchable(text: $searchText, prompt: "Search Entries")
//                            .overlay {
//                                if filteredEntries.isEmpty {
//                                    ContentUnavailableView.search(text: searchText)
//                                }
//                            }
                        }
                        Spacer()
                    }
                    .padding(.bottom, 40)
                    .padding(.top, 4)
            }
            .navigationTitle("Saved Entries")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            // MARK: - Entries List Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    sortEntry
                }
                ToolbarItem(placement: .primaryAction) {
                    addEntry
                }
            }
            .toolbarBackground(Theme.entryAndRecipesBackground, for: .navigationBar)
            // Sort Entries by Date
            .onChange(of: sort) { newSort in
                entries.nsSortDescriptors = sort(order: newSort)
            }
        }
    }

    func sort(order: Sort) -> [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \Entry.timeStamp, ascending: order == .ascending)]
    }
    
}


struct EntriesListView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesListView()
    }
}

struct SearchConfig: Equatable {
    var query: String = ""
}

//MARK: - Extensions
private extension DateFormatter {
    static let monthFormatter: DateFormatter = {
        let formatter        = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
}

private extension EntriesListView {
    var addEntry: some View {
        NavigationLink(destination: NewEntryView()) {
            Symbols.addEntry
        }
        .font(.system(size: 28, weight: .thin))
        .foregroundColor(Color(.label))
    }
    
    var sortEntry: some View {
        Menu {
            Section {
                Text("Sort")
                Picker(selection: $sort) {
                    Label("Newest to Oldest", systemImage: "arrow.down").tag(Sort.descending)
                    Label("Oldest to Newest", systemImage: "arrow.up").tag(Sort.ascending)
                } label: {
                    Text("Sort By")
                }
            }
        } label: {
            Symbols.tripleDot
                .font(.system(size: 28, weight: .ultraLight))
                .foregroundColor(Color(.label))
        }
    }
}

