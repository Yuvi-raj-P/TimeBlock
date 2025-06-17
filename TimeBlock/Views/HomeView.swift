//
//  HomeView.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/5/25.
//
import SwiftUI
import DeviceActivity
import FamilyControls
import ManagedSettings

extension FamilyActivitySelection {
    var isEmpty: Bool {
        applicationTokens.isEmpty && categoryTokens.isEmpty && webDomainTokens.isEmpty
    }
}

struct HomeView: View {
    @AppStorage("isUninstallLock") private var isUninstallLock: Bool = false
    @AppStorage("isConfirmationDone") private var isConfirmationDone: Bool = false
    @AppStorage("isAppsSelected") private var isAppsSelected: Bool = false
    
    // Device Activity and Screen Time API variables
    @State private var homeContext: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
    @State private var filter = DeviceActivityFilter(
        segment: .daily(
            during: Calendar.current.dateInterval(
                of: .day, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone, .iPad])
    )
    let store = ManagedSettingsStore()
    
    let scene0Gradient = Gradient(colors: [Color(red: 0.682, green: 0.749, blue: 0.627), Color(red: 0.894, green: 0.914, blue: 0.796)])
    
    @State private var isAuthorized: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: scene0Gradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if !isAuthorized {
                    // Authorization Screen
                    VStack {
                        (Text("We take your privacy very seriously").font(.instrumentR(size: 49))
                            .foregroundColor(.black) + Text(" \n \n we only request permissions needed to help you, and we never collect or share your data.").foregroundColor(.black)).multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer().frame(height: geometry.size.height * 0.1)
                        Button(action: {
                            requestAuthorization()
                        }) {
                            Text("Proceed with Permission")
                                .font(.instrumentSan(size: 20))
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 28)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.black.opacity(1))
                                )
                        }
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.5)
                } else if !isConfirmationDone {
                    
                    VStack {
                        Text("Setting up your experience")
                            .font(.instrumentR(size: 36))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    }
                    .onAppear {
                        
                    }
                } else {
                    
                    ZStack {
                        DeviceActivityReport(homeContext, filter: filter)
                        
                        VStack {
                            Text("Welcome to TimeBlock")
                                .font(.instrumentI(size: 36))
                                .foregroundColor(.white)
                                .padding(.top, 30)
                            
                            if isAppsSelected {
                                Text("Your time-thieves are being tracked")
                                    .font(.instrumentR(size: 20))
                                    .foregroundColor(.black)
                                    .padding()
                            } else {
                                Text("No apps selected for tracking yet")
                                    .font(.instrumentR(size: 20))
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            
                            if isUninstallLock {
                                Text("Uninstall protection is active")
                                    .font(.instrumentSan(size: 16))
                                    .foregroundColor(.black.opacity(0.7))
                            } else {
                                Text("Uninstall protection is disabled")
                                    .font(.instrumentSan(size: 16))
                                    .foregroundColor(.black.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Text("This is the Time Sheet page")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.black)
                                .padding(.bottom, 30)
                        }
                    }
                }
            }
            .onAppear {
                checkCurrentAuthorizationStatus()
            }
        }
    }
    
    func checkCurrentAuthorizationStatus() {
        let center = AuthorizationCenter.shared
        isAuthorized = center.authorizationStatus == .approved
        
        if !isAuthorized {
            requestAuthorization()
        }
    }
    
    func checkAuthorization() async {
        let center = AuthorizationCenter.shared
        if center.authorizationStatus == .approved {
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
            return
        }
        
        do {
            try await center.requestAuthorization(for: .individual)
            DispatchQueue.main.async {
                if center.authorizationStatus == .approved {
                    self.isAuthorized = true
                } else {
                    self.isAuthorized = false
                    print("Authorization not approved. Status: \(center.authorizationStatus.rawValue)")
                }
            }
        } catch {
            print("Failed to request authorization: \(error)")
            DispatchQueue.main.async {
                self.isAuthorized = false
            }
        }
    }
    
    func requestAuthorization() {
        Task {
            await checkAuthorization()
        }
    }
}

#Preview{
    HomeView()
}
