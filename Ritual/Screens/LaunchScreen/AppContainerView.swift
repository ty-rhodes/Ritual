//
//  AppContainerView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 9/25/23.
//

import SwiftUI

struct AppContainerView: View {
    
    @State private var isLaunchScreenViewPresented = true
    
    var body: some View {
        if !isLaunchScreenViewPresented {
            TabBar()
        } else {
            LaunchScreen(isPresented: $isLaunchScreenViewPresented)
        }
    }
}

#Preview {
    AppContainerView()
}
