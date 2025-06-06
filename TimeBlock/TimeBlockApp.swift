//
//  TimeBlockApp.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/1/25.
//

import SwiftUI

@main
struct TimeBlockApp: App {
    @AppStorage("isOnBoardingDone") var isOnBoardingDone: Bool = false

        var body: some Scene {
            WindowGroup {
                if isOnBoardingDone {
                    ContentView()
                } else {
                    OnBoardingView(isOnBoardingDone: $isOnBoardingDone)
                }
            }
        }
}
