//
//  SettingsView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 3/21/23.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage(UserDefaultKeys.hapticsEnabled) private var isHapticsEnabled: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.entryAndRecipesBackground
                    .ignoresSafeArea()
                VStack {
                    // MARK: - Settings Form
                    Form {
//                        hapticsEnabler
                        brewStandards
                        termsOfService
                    }
                    .scrollContentBackground(.hidden)
                    .cornerRadius(20)
                    .padding(.horizontal, -4)
                }
            }
            .navigationTitle("General Info")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

//MARK: - Extensions
private extension SettingsView {
    var hapticsEnabler: some View {
        Section (header: Label("Haptics", systemImage: "hand.tap"),
                 footer: Text("This will turn haptics on and off.")) {
            Toggle(isOn: $isHapticsEnabled,
                   label: { Text("Enable Haptic Feedback")
            })
            .font(.system(size: 16, weight: .light))
        }
    }
    
    var brewStandards: some View {
        Section(header: Label("General Brewing Standards", systemImage: "mug")
            .foregroundColor(.secondary)) {
                Text("Water Temperature Range: 195-205 degrees.\n\nA broad ratio standard is 1:16 in grams.\n\nIf you don't have a scale, use 1 tablespoon of coffee for every 6 ounces of water.")
                    .font(.system(size: 16, weight: .light))
                    .minimumScaleFactor(0.6)
                    .fixedSize(horizontal: false, vertical: true)
            }
    }
    
    var termsOfService: some View {
        Section(header: Label("Legal", systemImage: "scroll")
            .foregroundColor(.secondary)){
                HStack {
                    Symbols.link
                    Link("Terms Of Service", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                }
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.black)
                
                HStack {
                    Symbols.link
                    Link("Privacy Policy", destination: URL(string: "https://sites.google.com/view/ritualbrewandrenew/home")!)
                }
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.black)
            }
    }
}
