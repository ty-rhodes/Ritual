//
//  AppContainerView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 9/25/23.
//

import SwiftUI

struct AppContainerView: View {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    @State private var isLaunchScreenViewPresented = true
    
    var body: some View {
        if !isLaunchScreenViewPresented {
            TabBar()
                .sheet(isPresented: $isFirstTime, content: {
                    OnboardScreen()
                        .interactiveDismissDisabled()
                })
        } else {
            LaunchScreen(isPresented: $isLaunchScreenViewPresented)
        }
    }
}

#Preview {
    AppContainerView()
}
