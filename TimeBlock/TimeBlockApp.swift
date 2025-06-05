//
//  TimeBlockApp.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/1/25.
//

import SwiftUI

@main
struct TimeBlockApp: App {
    @AppStorage("isOnboardingDone") var isOnboardingDone: Bool = false

        var body: some Scene {
            WindowGroup {
                if isOnboardingDone {
                    ContentView()
                } else {
                    OnBoardingView(isOnBoardingDone: $isOnboardingDone)
                }
            }
        }
}
