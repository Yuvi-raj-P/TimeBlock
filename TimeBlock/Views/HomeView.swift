//
//  HomeView.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/5/25.
//
import SwiftUI
import DeviceActivity
import FamilyControls

extension FamilyActivitySelection {
    var isEmpty: Bool {
        applicationTokens.isEmpty && categoryTokens.isEmpty && webDomainTokens.isEmpty
    }
}

struct HomeView: View {
    
    @State private var currentScene: Int = 0
    @State private var isAuthorized: Bool = true
    @State private var pickerDismissedWithoutSelection = false
    @State private var isAppsSelected: Bool = false
    @State private var familyActivitySelection = FamilyActivitySelection()
    @State private var showPickerInline: Bool = false
    
    //Sparkle Variables
    @State private var sparkles: [Sparkle] = []
    
    let scene0Gradient = Gradient(colors: [Color(red: 0.682, green: 0.749, blue: 0.627), Color(red: 0.894, green: 0.914, blue: 0.796)])
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: scene0Gradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if currentScene == 0 {
                    if isAuthorized {
                        if !isAppsSelected {
                            if showPickerInline {
                                VStack {
                                    (Text("What’s stealing your ")
                                        .font(.instrumentR(size: 50))
                                        .foregroundColor(.black)
                                     + Text("time?").font(.instrumentI(size: 50))
                                        .foregroundColor(.white)
                                    )
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    
                                    
                                    
                                    Spacer().frame(height: geometry.size.height * 0.03)
                                    
                                    Text("Choose at least one now — you can always come back to it.")
                                        .font(.instrumentSan(size: 18))
                                        .foregroundColor(pickerDismissedWithoutSelection ? .black.opacity(1) : .black.opacity(0.5))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(3)
                                        .padding(.horizontal)
                                    Spacer().frame(height: geometry.size.height * 0.03)
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.black.opacity(0.85))
                                            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                                        
                                        FamilyActivityPicker(selection: $familyActivitySelection)
                                            .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.53)
                                            .clipped()
                                            .preferredColorScheme(.dark)
                                    }
                                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.55)
                                    .padding(.horizontal, 5)
                                    
                                    
                                    
                                    Button(action: {
                                        if !familyActivitySelection.isEmpty {
                                                                                        self.isAppsSelected = true
                                                                                        self.pickerDismissedWithoutSelection = false
                                                                                        withAnimation {
                                                                                            self.showPickerInline = false
                                                                                        }
                                                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                                                                self.currentScene = 1
                                                                                            }
                                                                                        }
                                                                                    }
                                    }) {
                                        Text("Proceed")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.white)
                                            .padding(.vertical, 12)
                                            .padding(.horizontal, 50)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.black.opacity(familyActivitySelection.isEmpty ? 0.6 : 1.0))
                                            )
                                    }
                                    .disabled(familyActivitySelection.isEmpty)
                                }
                                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.6)
                            } else {
                                
                                VStack {
                                    (Text("Pick your")
                                        .font(.instrumentR(size: 60))
                                        .foregroundColor(.black)
                                    )
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    
                                    Text("time-thieves.")
                                        .font(.instrumentR(size: 64))
                                        .foregroundColor(.white)
                                    
                                    Spacer().frame(height: geometry.size.height * 0.03)
                                    
                                    Text(pickerDismissedWithoutSelection ? "Please select at least 1 app to continue" : "We'll help you stay aware — nothing's locked, everything's adjustable later.")
                                        .font(.instrumentSan(size: 18))
                                        .foregroundColor(pickerDismissedWithoutSelection ? .black.opacity(1) : .black.opacity(0.5))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(3)
                                        .padding(.horizontal)
                                    Spacer().frame(height: geometry.size.height * 0.2)
                                    Button(action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            self.showPickerInline = true
                                        }
                                        self.pickerDismissedWithoutSelection = false
                                    }) {
                                        Text("Select Apps")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.white)
                                            .padding(.vertical, 12)
                                            .padding(.horizontal, 50)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.black.opacity(1))
                                            )
                                    }
                                }
                                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.7)
                            }
                        }
                       
                        
                    } else {
                        
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
                    }

                } else if currentScene == 1 {
                    // Scene 1: Sparkle Animation
                    ZStack{
                        ZStack {
                            VStack{
                                Text("Well picked!")
                                    .font(.instrumentI(size: 64))
                                    .foregroundColor(.black.opacity(0.6))
                                    .zIndex(1)
                                Text("Let’s keep you focused.")
                                    .font(.instrumentR(size: 64))
                                    .foregroundColor(.white)
                            }
                            ForEach(sparkles) { sparkle in
                                PulseStarViewa(sparkle: sparkle)
                            }
                        }
                        .onAppear {
                            pulseBurst()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    self.currentScene = 2
                                }
                            }
                        }
                        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                    }
                } else if currentScene == 2 {
                    // Scene 2: Placeholder content
                    VStack {
                        Text("This is Scene 2!")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text("Placeholder content goes here.")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                }
                
            }
            .ignoresSafeArea()
            .onAppear(){
                // Request authorization if not already determined
                if !isAuthorized { // Only request if status is not yet approved
                    //requestAuthorization() //Will turn this back on at production
                }
            }
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
    
    func pulseBurst() {
        sparkles.removeAll()
        for i in 0..<120 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.025) {
                let sparkle = Sparkle(
                    id: UUID(),
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                    size: CGFloat.random(in: 20...60),
                    rotation: Double.random(in: 0...360)
                )
                sparkles.append(sparkle)
            }
        }
    }
}

struct Sparkle: Identifiable {
    let id: UUID
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let rotation: Double
}
struct FourPointStar: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = rect.midX
        let midY = rect.midY
        let size = min(rect.width, rect.height)

        path.move(to: CGPoint(x: midX, y: midY - size / 2))
        path.addLine(to: CGPoint(x: midX + size / 10, y: midY - size / 10))

        path.addLine(to: CGPoint(x: midX + size / 2, y: midY)) // Right
        path.addLine(to: CGPoint(x: midX + size / 10, y: midY + size / 10))

        path.addLine(to: CGPoint(x: midX, y: midY + size / 2)) // Bottom
        path.addLine(to: CGPoint(x: midX - size / 10, y: midY + size / 10))

        path.addLine(to: CGPoint(x: midX - size / 2, y: midY)) // Left
        path.addLine(to: CGPoint(x: midX - size / 10, y: midY - size / 10))

        path.closeSubpath()
        return path
    }
}


struct PulseStarViewa: View {
    let sparkle: Sparkle
    @State private var scale: CGFloat = 0.01
    @State private var opacity: Double = 1.0

    var body: some View {
        FourPointStar()
            .fill(Color.white)
            .frame(width: sparkle.size, height: sparkle.size)
            .position(x: sparkle.x, y: sparkle.y)
            .scaleEffect(scale)
            .opacity(opacity)
            .rotationEffect(.degrees(sparkle.rotation))
            .shadow(color: .white.opacity(0.7), radius: sparkle.size / 5)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4)) {
                    scale = 1.2
                }
                withAnimation(.easeInOut(duration: 1.2).delay(0.4)) {
                    scale = 1.0
                }
                withAnimation(.easeInOut(duration: 1.0).delay(1.5)) {
                    opacity = 0
                }
            }
    }
}


#Preview{
    HomeView()
}
