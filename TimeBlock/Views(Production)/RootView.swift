//
//  RootView.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/17/25.
//
import SwiftUI

struct RootView: View {
    @StateObject private var appState = AppStateViewModel()

    var body: some View {
        Group {
            switch appState.currentLaunchScreen {
            case .intro:
                IntroView()
                    .environmentObject(appState)

            case .permissions:
                PermissionsView()
                    .environmentObject(appState)

            case .passiveOnboarding:
                PassiveOnboardingView()
                    .environmentObject(appState)

            case .home:
                Home()
                    .environmentObject(appState)
            }
        }
    }
}
