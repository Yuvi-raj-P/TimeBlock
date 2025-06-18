//
//  IntroView.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/17/25.
//

import SwiftUI
import FamilyControls

struct IntroView: View {
    // MARK: - Properties
    @EnvironmentObject var appState: AppStateViewModel
    
    @State private var arrowOffsetY: CGFloat = 0
    @State private var textOpacity: Double = 0
    @State private var currentScene: Int = 0
    @State private var scene2TextOpacity: Double = 0
    @State private var scene3TextOpacity: Double = 0
    @State private var isAuthorized: Bool = false
    
    // MARK: - Gradients
    private let sceneGradients: [Gradient] = [
        Gradient(colors: [Color(red: 0.8, green: 0.706, blue: 0.91), Color(red: 0.988, green: 0.937, blue: 0.933)]),
        Gradient(colors: [Color(red: 0.655, green: 0.733, blue: 0.78), Color(red: 0.89, green: 0.918, blue: 0.945)]),
        Gradient(colors: [Color(red: 0.776, green: 0.847, blue: 1), Color(red: 0.906, green: 0.914, blue: 0.941)])
    ]
    
    // MARK: - Animation Constants
    private let fadeInDuration: Double = 1.5
    private let arrowAnimationDuration: Double = 1.0
    private let transitionDuration: Double = 0.7
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: sceneGradients[min(currentScene, sceneGradients.count - 1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Scenes content
                Group {
                    if currentScene == 0 {
                        scene0Content(in: geometry)
                    } else if currentScene == 1 {
                        scene1Content(in: geometry)
                    } else if currentScene == 2 {
                        scene2Content(in: geometry)
                    }
                }
            }
            .gesture(createSwipeGesture())
            .onChange(of: currentScene) { _ in
                resetArrowAnimation()
            }
        }
    }
    
    // MARK: - Scene Content Views
    private func scene0Content(in geometry: GeometryProxy) -> some View {
        ZStack {
            VStack(spacing: geometry.size.height * 0.02) {
                HStack {
                    Text("Time").font(.instrumentR(size: adaptiveFontSize(baseFontSize: 55, geometry: geometry)))
                        .foregroundColor(.black)
                    Text("flies:").font(.instrumentI(size: adaptiveFontSize(baseFontSize: 55, geometry: geometry)))
                        .foregroundColor(.white)
                }
                .opacity(textOpacity)
                .animation(Animation.easeIn(duration: fadeInDuration).delay(0.5), value: textOpacity)
                
                Text("keep it yours")
                    .font(.instrumentI(size: adaptiveFontSize(baseFontSize: 48, geometry: geometry)))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)
                    .animation(Animation.easeIn(duration: fadeInDuration).delay(1.0), value: textOpacity)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
            
            swipeIndicator(in: geometry, opacity: textOpacity, delay: 1.5)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.arrowOffsetY = -10
                        self.textOpacity = 1
                    }
                }
        }
    }
    
    private func scene1Content(in geometry: GeometryProxy) -> some View {
        ZStack {
            VStack(spacing: geometry.size.height * 0.03) {
                (Text("Procrastination drains more than just ")
                    .font(.instrumentR(size: adaptiveFontSize(baseFontSize: 44, geometry: geometry)))
                    .foregroundColor(.black) +
                 Text("time")
                    .font(.instrumentI(size: adaptiveFontSize(baseFontSize: 44, geometry: geometry)))
                    .foregroundColor(.white) +
                 Text(".")
                    .font(.instrumentR(size: adaptiveFontSize(baseFontSize: 44, geometry: geometry)))
                    .foregroundColor(.white)
                )
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .opacity(scene2TextOpacity)
                .animation(Animation.easeIn(duration: fadeInDuration).delay(0.5), value: scene2TextOpacity)
                
                Text("It leaves us tired and behind on what really matters.")
                    .font(.instrumentSan(size: adaptiveFontSize(baseFontSize: 17, geometry: geometry)))
                    .foregroundColor(.black.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .opacity(scene2TextOpacity)
                    .animation(Animation.easeIn(duration: fadeInDuration).delay(1.0), value: scene2TextOpacity)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
            
            swipeIndicator(in: geometry, opacity: scene2TextOpacity, delay: 1.5)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.scene2TextOpacity = 1
                    }
                }
        }
    }
    
    private func scene2Content(in geometry: GeometryProxy) -> some View {
        ZStack {
            VStack(spacing: geometry.size.height * 0.01) {
                Text("Welcome to")
                    .font(.instrumentR(size: adaptiveFontSize(baseFontSize: 60, geometry: geometry)))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text("Timey")
                    .font(.instrumentI(size: adaptiveFontSize(baseFontSize: 64, geometry: geometry)))
                    .foregroundColor(.white)
                
                Spacer().frame(height: geometry.size.height * 0.01)
                
                Text("One small change ◦ A more mindful day")
                    .font(.instrumentR(size: adaptiveFontSize(baseFontSize: 22, geometry: geometry)))
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .opacity(scene3TextOpacity)
            .animation(Animation.easeIn(duration: fadeInDuration).delay(0.5), value: scene3TextOpacity)
            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
            
            Button(action: {
                withAnimation(.easeInOut(duration: transitionDuration)) {
                    scene3TextOpacity = 0
                }
                Task {
                    await checkAuthorization()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: transitionDuration)) {
                            appState.markIntroSeen()
                        }
                    }
                }
            }) {
                Text("Continue")
                    .font(.instrumentSan(size: adaptiveFontSize(baseFontSize: 18, geometry: geometry)))
                    .foregroundColor(.white)
                    .padding(.vertical, geometry.size.height * 0.015)
                    .padding(.horizontal, geometry.size.width * 0.12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black)
                    )
            }
            .opacity(scene3TextOpacity)
            .animation(Animation.easeIn(duration: fadeInDuration).delay(2.0), value: scene3TextOpacity)
            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.89)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.scene3TextOpacity = 1
                }
            }
        }
    }
    
    // MARK: - Helper Views
    private func swipeIndicator(in geometry: GeometryProxy, opacity: Double, delay: Double) -> some View {
        VStack(spacing: 10) {
            Image("ArrowUp")
                .colorInvert()
                .offset(y: arrowOffsetY)
                .animation(
                    Animation.easeInOut(duration: arrowAnimationDuration)
                        .repeatForever(autoreverses: true),
                    value: arrowOffsetY
                )
            
            Text("Swipe up")
                .font(.instrumentSan(size: adaptiveFontSize(baseFontSize: 20, geometry: geometry)))
                .foregroundColor(.black)
        }
        .opacity(opacity)
        .animation(Animation.easeIn(duration: fadeInDuration).delay(delay), value: opacity)
        .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.89)
    }
    
    // MARK: - Helper Functions
    private func adaptiveFontSize(baseFontSize: CGFloat, geometry: GeometryProxy) -> CGFloat {
        let screenWidth = geometry.size.width
        let referenceWidth: CGFloat = 390
        
        let scaleFactor = min(screenWidth / referenceWidth, 1.1)
        
        let sizeAdjustment: CGFloat = baseFontSize > 40 ? 0.90 : 1
        return max(12, baseFontSize * scaleFactor * sizeAdjustment)
    }
    
    private func createSwipeGesture() -> some Gesture {
        DragGesture().onEnded { value in
            if value.translation.height < -50 {
                if currentScene == 0 {
                    transitionToNextScene(from: 0, fadingOut: $textOpacity)
                } else if currentScene == 1 {
                    transitionToNextScene(from: 1, fadingOut: $scene2TextOpacity)
                }
            }
        }
    }
    
    private func transitionToNextScene(from currentScene: Int, fadingOut opacity: Binding<Double>) {
        withAnimation(.easeInOut(duration: transitionDuration)) {
            opacity.wrappedValue = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: transitionDuration)) {
                self.currentScene = currentScene + 1
            }
        }
    }
    
    private func resetArrowAnimation() {
        arrowOffsetY = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(Animation.easeInOut(duration: arrowAnimationDuration).repeatForever(autoreverses: true)) {
                arrowOffsetY = -10
            }
        }
    }
    
    // MARK: - Authorization
    private func checkAuthorization() async {
        let center = AuthorizationCenter.shared
        do {
            try await center.requestAuthorization(for: .individual)
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
        } catch {
            print("Failed to get authorization: \(error)")
            DispatchQueue.main.async {
                self.isAuthorized = false
            }
        }
    }
}

#Preview {
    IntroView()
}
