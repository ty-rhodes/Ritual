//
//  TabBar.swift
//  Ritual
//
//  Created by Tyler Rhodes on 6/17/23.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject var recipesViewModel: RecipesViewModel
    
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: - Custom Tab Group
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .journalEntries:
                    EntriesListView()
                case .brewRecipes:
                    SavedRecipesListView()
                case .settings:
                    SettingsView()
                case .brew:
                    BrewView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // MARK: - TabView
            HStack(spacing: 34) {
                Spacer()
                ForEach(tabItems) { item in
                    if item.tab == .brew {
                        BrewTabButton(selectedTab: $selectedTab, item: item)
                            .offset(x: -14,y: -14)
                    } else {
                        TabButton(selectedTab: $selectedTab, item: item)
                    }
                }
            }
            .padding(.horizontal, 8)
            .frame(width: 330, height: 30, alignment: .top)
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(.black)
            .background(.white, in: RoundedRectangle(cornerRadius: 60, style: .continuous))
            .overlay( RoundedRectangle(cornerRadius: 60).stroke(Theme.entryAndRecipesBackground, lineWidth: 3))
            .shadow(color: Color.black.opacity(0.4), radius: 28, x: 0, y: 14)
            .ignoresSafeArea()
        }
    }
}

struct TabButton: View {
    
    @Binding var selectedTab: Tab
    let item: TabItem

    var body: some View {
        Button {
            selectedTab = item.tab
        } label: {
            VStack(spacing: 2) {
                item.icon
                    .font(.body.bold())
                    .frame(width: 38, height: 26)
                    .foregroundStyle(selectedTab == item.tab ? .black : .white)
                Text(item.text)
                    .font(.caption2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
        }
        .offset(y: -14)
        .foregroundStyle(selectedTab == item.tab ? .primary : .secondary)
    }
}

struct BrewTabButton: View {
    
    @Binding var selectedTab: Tab
    let item: TabItem

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Theme.brewBackground)
                .frame(width: 58, height: 58)
            
            VStack(spacing: 2) {
                item.icon
                    .font(.body.bold())
                    .frame(width: 38, height: 22)
                    .offset(x: 2, y: 2)
                    .foregroundStyle(selectedTab == item.tab ? .black : .white)
                Text(item.text)
                    .font(.system(size: 9))
                    .minimumScaleFactor(0.6)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
        }
        .onTapGesture {
            selectedTab = item.tab
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

private extension TabBar {
    
    func didDismiss() {
        print("dismiss")
    }
}
