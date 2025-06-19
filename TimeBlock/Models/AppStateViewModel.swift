//
//  AppStateViewModel.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/17/25.
//

import Foundation
import Combine
import FamilyControls

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
    @Published var isUninstallProtectionEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isUninstallProtectionEnabled, forKey: "isUninstallProtectionEnabled")
        }
    }
    @Published var deviceActivityReady: Bool = false
    @Published var isLoadingDeviceActivity: Bool = false
    
    init() {
        hasSeenIntro = UserDefaults.standard.bool(forKey: "hasSeenIntro")
        hasGrantedPermissions = UserDefaults.standard.bool(forKey: "hadGrantedPermissions")
        onBoardingCompleted = UserDefaults.standard.bool(forKey: "onBoardingCompleted")
        isUninstallProtectionEnabled = UserDefaults.standard.bool(forKey: "isUninstallProtectionEnabled")
    }
    
    var currentLaunchScreen: LaunchScreenState {
        if !hasSeenIntro {
            return .intro
        } else if !hasGrantedPermissions {
            return .permissions
        } else if !onBoardingCompleted {
            return .passiveOnboarding
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
    func markOnboardingCompleted() {
        onBoardingCompleted = true
    }
    func startDeviceActivityLoad() {
        isLoadingDeviceActivity = true
        deviceActivityReady = false
        
    }
    func saveBlockSchedule(schedule: BlockSchedule) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(schedule) {
            UserDefaults.standard.set(data, forKey: "userBlockSchedule")
        }
    }
    func activateBlockSchedule(schedule: BlockSchedule) {
        ScheduleManager.shared.activateSchedule(schedule: schedule)
    }
}
