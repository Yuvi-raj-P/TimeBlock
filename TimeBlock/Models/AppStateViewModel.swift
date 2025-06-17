//
//  AppStateViewModel.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/17/25.
//

import Foundation
import Combine

class AppStateViewModel: ObservableObject {
    @Published var hasSeenIntro: Bool {
        didSet { UserDefaults.standard.set(hasSeenIntro, forKey: "hasSeenIntro") }
    }
    @Published var hasGrantedPermissions: Bool {
        didSet { UserDefaults.standard.set(hasGrantedPermissions, forKey: "hadGrantedPermissions")}
    }
    @Published var onBoardingCompleted: Bool {
        didSet {UserDefaults.standard.set(onBoardingCompleted, forKey: "onBoardingCompleted")}
    }
    @Published var deviceActivityReady: Bool = false
    @Published var isLoadingDeviceActivity: Bool = false
    
    init() {
        hasSeenIntro = UserDefaults.standard.bool(forKey: "hasSeenIntro")
        hasGrantedPermissions = UserDefaults.standard.bool(forKey: "hadGrantedPermissions")
        onBoardingCompleted = UserDefaults.standard.bool(forKey: "onBoardingCompleted")
    }
    
    var currentLaunchScreen: LaunchScreenState {
        if !hasSeenIntro {
            return .intro
        } else if !hasGrantedPermissions {
            return .permissions
        } else if !onBoardingCompleted {
            return .onboarding
        } else {
            return .home
        }
    }
    
    func markIntroSeen() {
        hasSeenIntro = true
    }
    func markPermissionsGranted() {
        hasGrantedPermissions = true
    }
}
