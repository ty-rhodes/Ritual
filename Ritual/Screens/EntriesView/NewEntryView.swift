//
//  NewEntryView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 6/21/23.
//

import SwiftUI

struct NewEntryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entry.timeStamp, ascending: false)], animation: .default)
    
    private var entries: FetchedResults<Entry>
    
    @StateObject private var viewModel = EntriesViewModel(viewContext: PersistenceController.shared.viewContext)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.entryAndRecipesBackground
                    .ignoresSafeArea()
                // MARK: - New Entry TextFields
                VStack {
                    newEntryTitle
                    newEntryEditor
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 40)
            }
            .navigationBarBackButtonHidden(true)
            // MARK: - New Entry Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    addEntryButton
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

struct NewEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NewEntryView()
    }
}

//MARK: - Extensions
private extension NewEntryView {
    
    var customEntryTitle: some View {
        ZStack {
            if viewModel.newEntryTitle.isEmpty {
                Text("Subject")
                    .foregroundStyle(.red)
                
                TextField("", text: $viewModel.newEntryTitle)
                    .onTapGesture {
                        if self.viewModel.newEntryTitle.isEmpty {
                            DispatchQueue.main.async {
                                self.viewModel.newEntryTitle = " "
                                self.viewModel.newEntryTitle = ""
                            }
                        }
                    }
            }
        }
        .font(.system(size: 24, weight: .light))
        .frame(width: 350, height: 20)
        .autocorrectionDisabled(true)
        .padding()
    }
    
    var newEntryTitle: some View {
        TextField("Subject", text: $viewModel.newEntryTitle)
            .font(.system(size: 24, weight: .light))
            .frame(width: 350, height: 20)
            .autocorrectionDisabled(true)
            .padding()
    }
    
    var newEntryEditor: some View {
        TextField("Write your entry here...", text: $viewModel.newEntry, axis: .vertical)
            .font(.system(size: 24, weight: .light))
            .padding()
    }
    
    var clearButton: some View {
        Button("Clear") {
            viewModel.newEntry = ""
        }
        .font(.system(size: 20, weight: .light))
        .foregroundColor(Color(uiColor: .label))
        .disabled(viewModel.newEntry.isEmpty) // Disable the button when newEntry is empty
    }
    
    var addEntryButton: some View {
        Button("Done") {
            viewModel.saveNewEntry(title: viewModel.newEntryTitle, text: viewModel.newEntry)
            viewModel.newEntryTitle = ""
            viewModel.newEntry = ""
            presentationMode.wrappedValue.dismiss()
        }
        .frame(alignment: .center)
        .font(.system(size: 20, weight: .light))
        .foregroundColor(.black)
        .disabled(viewModel.newEntry.isEmpty) // Disable the button when newEntry is empty
    }
}
