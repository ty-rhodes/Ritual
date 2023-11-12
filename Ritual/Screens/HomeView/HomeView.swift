//
//  HomeView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 3/20/23.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Entry.timeStamp, ascending: false)], animation: .default)
    
    private var entries: FetchedResults<Entry>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.recipe, ascending: false)], animation: .default)
    
    private var recipes: FetchedResults<Recipe>
    
    @State private var scrollOffset: CGFloat  = 0
    @State private var contentHeight: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.homeBackground
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                GeometryReader { geometry in
                    let tabBarHeight: CGFloat = 80
                    ScrollView {
                        Spacer()
                        VStack {
                            // MARK: - App Greeting
                            greetingView
                            // MARK: - Cups Brewed and Entries Saved
                            brewAndCount
                            //MARK: - Recent Brews
                            VStack(alignment: .center, spacing: 10) {
                                HStack(spacing: 74) {
                                    Text("Recent Brews")
                                        .font(.system(size: 26, weight: .light))
                                        .padding(.horizontal, 8)
                                    // MARK: - View All Brews Button
                                    viewAllBrewsButton
                                }
                                // MARK: - Recipe ScrollView
                                if recipes.isEmpty {
                                    BrewNowCardEmptyState()
                                } else {
                                    recentBrewsScrollView
                                }
                            }
                            .padding(.vertical, 30)
                            //MARK: - Recent Entries
                            VStack(alignment: .center, spacing: 10) {
                                HStack(spacing: 66) {
                                    Text("Recent Entries")
                                        .font(.system(size: 26, weight: .light))
                                        .padding(.horizontal, 8)
                                    // MARK: - View All Entries Button
                                    viewAllEntriesButton
                                }
                                // MARK: - Entries ScrollView
                                if entries.isEmpty {
                                    JournalEntryCardEmptyState()
                                } else {
                                    recentEntriesScrollView
                                }
                            }
                        }
                        .frame(width: geometry.size.width)
                        .background(
                            GeometryReader { innerGeometry -> Color in
                                DispatchQueue.main.async {
                                    self.contentHeight = innerGeometry.frame(in: .global).maxY
                                }
                                return Color.clear
                            }
                        )
                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                            self.scrollOffset = value
                        }
                        .padding(.bottom, scrollOffset > 0 ? 0 : tabBarHeight)
                        .padding(.top, scrollOffset > 0 ? -scrollOffset : 0)
                        .edgesIgnoringSafeArea(.bottom)
                        // MARK: - Date Overlay
                        .overlay(alignment: .topLeading) {
                            HStack {
                                Text(Date().displayFormat)
                                Spacer()
                            }
                            .foregroundColor(Color(.label))
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical, 60)
//                .padding(.vertical, 84)
                .padding(.horizontal, 1)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//MARK: - Extensions
private extension HomeView {
    
    var greetingView: some View {
        HStack(spacing: 60) {
            Text("Let's get this day going.")
                .font(.system(size: 60, weight: .light))
                .frame(width: 300, height: 120, alignment: .leading)
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.6)
                .padding(.vertical, 30)
            
            Text("")
        }
    }
    
    var brewAndCount: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack {
                Text("\(recipes.count)")
                    .font(.system(size: 40, weight: .light))
                    .bold()
                Text("Cups Brewed")
                    .font(.system(size: 16, weight: .light))
            }
            Divider()
                .background(Color.white)
                .padding()
            VStack {
                Text("\(entries.count)")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(.black)
                    .bold()
                Text("Journal Entries")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.black)
                
            }
        }
        .frame(width: 365, height: 120)
        .background(Color.white)
        .cornerRadius(30)
        .padding(.vertical, 20)
    }
    
    var viewAllBrewsButton: some View {
        NavigationLink(destination: SavedRecipesListView()) {
            Text("View All")
                .frame(width: 120, height: 40)
                .background(.clear)
                .font(.system(size: 14, weight: .semibold))
                .overlay( RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 1))
                .controlSize(.large)
                .padding(3)
        }
        .foregroundColor(.black)
    }
    
    var viewAllEntriesButton: some View {
        NavigationLink(destination: EntriesListView()) {
            Text("View All")
                .frame(width: 120, height: 40)
                .background(.clear)
                .font(.system(size: 14, weight: .semibold))
                .overlay( RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 1))
                .controlSize(.large)
                .padding(3)
        }
        .foregroundColor(.black)
    }
    
    var recentBrewsScrollView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(recipes) { recipe in
                    NavigationLink( destination: SavedRecipesView(recipe: recipe)) {
                        BrewNowCard(brewNowCoffeeType: recipe.method ?? "",
                                    brewNowCupAmount: Int(recipe.cups))
                    }
                }
                .frame(width: 100, height: 185)
                .padding(.horizontal)
            }
            .padding(.horizontal)
        }
    }
    
    var recentEntriesScrollView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(entries) { entry in
                    NavigationLink(destination: SavedEntryView(entry: entry)) {
                        JournalEntryCard(entryDate: entry.timeStamp?.entryDate ?? "N/A",
                                         entryTitle: entry.entryTitle ?? "N/A",
                                         entry: entry.entry ?? "N/A")
                    }
                }
                .frame(width: 100, height: 185)
                .padding(.horizontal)
            }
            .padding(.horizontal)
        }
    }
}

extension Date {
    var displayFormat: String {
        self.formatted(date: .long, time: .omitted)
    }
    
    var timeFormat: String {
        self.formatted(
            .dateTime
                .year(.defaultDigits)
                .month(.wide)
                .day(.twoDigits)
                .hour()
                .minute()
        )
    }
}


