//
//  OnBoarding.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/3/25.
//

import SwiftUI
import DeviceActivity
import FamilyControls


struct OnBoardingView: View {
    @Binding var isOnBoardingDone: Bool
    @State private var arrowOffsetY: CGFloat = 0
    @State private var textOpacity: Double = 0
    @State private var currentScene: Int = 2
    @State private var scene2TextOpacity: Double = 0
    @State private var scene3TextOpacity: Double = 0
    @State private var isAuthorized: Bool = false
    
    let scene0Gradient = Gradient(colors: [Color(red: 0.8, green: 0.706, blue: 0.91), Color(red: 0.988, green: 0.937, blue: 0.933)])
    let scene1Gradient = Gradient(colors: [Color(red: 0.655, green: 0.733, blue: 0.78), Color(red: 0.89, green: 0.918, blue: 0.945)])
    
    let scene2Gradient = Gradient(colors: [Color(red: 0.776, green: 0.847, blue: 1), Color(red: 0.906, green: 0.914, blue: 0.941)])
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                LinearGradient(
                    gradient: currentScene == 0 ? scene0Gradient :
                              currentScene == 1 ? scene1Gradient : scene2Gradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if currentScene == 0 {
                    VStack {
                        HStack{
                            Text("Time").font(.instrumentR(size: 55)).foregroundColor(.black)
                            Text("flies:").font(.instrumentI(size: 55)).foregroundColor(.white)
                        }
                        .opacity(textOpacity)
                        .animation(Animation.easeIn(duration: 1.5).delay(0.5), value: textOpacity)
                        
                        Text("keep it yours").font(.instrumentI(size: 48)).foregroundColor(.black).multilineTextAlignment(.center)
                            .opacity(textOpacity)
                            .animation(Animation.easeIn(duration: 1.5).delay(1.0), value: textOpacity)
                    }
                    VStack{
                        Image("ArrowUp").colorInvert().offset(y:arrowOffsetY).animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: arrowOffsetY)
                            .opacity(textOpacity)
                            .animation(Animation.easeIn(duration: 1.5).delay(1.5), value: textOpacity)
                        
                        Text("Swipe up").font(.instrumentSan(size: 20)).foregroundColor(.black).multilineTextAlignment(.center)
                            .opacity(textOpacity)
                            .animation(Animation.easeIn(duration: 1.5).delay(2.0), value: textOpacity)
                    }.position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.89)
                    .onAppear {
                        self.arrowOffsetY = -10
                        self.textOpacity = 1
                    }
                   
                }
                
                if currentScene == 1 {
                    VStack {
                        (Text("Procrastination drains more than just ")
                            .font(.instrumentR(size: 44))
                            .foregroundColor(.black) +
                         Text("time")
                            .font(.instrumentI(size: 44))
                            .foregroundColor(.white) +
                         Text(".")
                            .font(.instrumentR(size: 44))
                            .foregroundColor(.black)
                        )
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .opacity(scene2TextOpacity)
                        .animation(Animation.easeIn(duration: 1.5).delay(0.5), value: scene2TextOpacity)
                        Spacer().frame(height: geometry.size.height * 0.03)
                        Text("it leaves us tired and behind on what really matters.").font(.system(size: 18)).foregroundColor(.black.opacity(0.5)).multilineTextAlignment(.center)
                            .opacity(scene2TextOpacity)
                            .animation(Animation.easeIn(duration: 1.5).delay(1.0), value: scene2TextOpacity)
                    }
                    VStack{
                        Image("ArrowUp").colorInvert().offset(y:arrowOffsetY).animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: arrowOffsetY)
                            .opacity(scene2TextOpacity)
                            .animation(Animation.easeIn(duration: 1.5).delay(1.5), value: scene2TextOpacity)
                        
                        Text("Swipe up").font(.instrumentSan(size: 20)).foregroundColor(.black).multilineTextAlignment(.center)
                            .opacity(scene2TextOpacity)
                            .animation(Animation.easeIn(duration: 1.5).delay(2.0), value: scene2TextOpacity)
                    }.position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.89)
                    .onAppear {
                        withAnimation(Animation.easeIn(duration: 1.5).delay(0.5)) {
                            self.scene2TextOpacity = 1
                        }
                    }
                    
                }
            }
            .gesture(
                DragGesture().onEnded { value in
                    if value.translation.height < -50 {
                        if currentScene == 0 {
                            withAnimation(.easeInOut(duration: 0.7)) {
                                textOpacity = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeInOut(duration: 0.7)) {
                                    currentScene = 1
                                }
                            }
                        } else if currentScene == 1 {
                            withAnimation(.easeInOut(duration: 0.7)) {
                                scene2TextOpacity = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeInOut(duration: 0.7)) {
                                    currentScene = 2
                                }
                            }
                        }
                    }
                }
            )
            .onChange(of: currentScene) { newValue in
                arrowOffsetY = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        arrowOffsetY = -10
                    }
                }
            }
            
            if currentScene == 2 {
                VStack {
                    (Text("Welcome to ")
                        .font(.instrumentR(size: 60))
                        .foregroundColor(.black)
                    )
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(scene2TextOpacity)
                    .animation(Animation.easeIn(duration: 1.5).delay(0.5), value: scene2TextOpacity)
                    Text("Timey")
                        .font(.instrumentI(size: 64))
                        .foregroundColor(.white).opacity(scene2TextOpacity)
                        .animation(Animation.easeIn(duration: 1.5).delay(0.5), value: scene2TextOpacity)
                    Spacer().frame(height: geometry.size.height * 0.03)
                    Text("One small change ◦ A more mindful day").font(.instrumentR(size: 22)).foregroundColor(.black.opacity(0.7)).multilineTextAlignment(.center)
                        .opacity(scene2TextOpacity)
                        .animation(Animation.easeIn(duration: 1.5).delay(1.0), value: scene2TextOpacity)
                }.position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.7)) {
                        scene2TextOpacity = 0
                    }
                    Task {
                        await checkAuthorization()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 0.7)) {
                                isOnBoardingDone = true
                            }
                        }
                    }
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(1))
                        )
                }
                .opacity(scene2TextOpacity)
                .animation(Animation.easeIn(duration: 1.5).delay(2.0), value: scene2TextOpacity)
                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.89)
                .onAppear {
                    withAnimation(Animation.easeIn(duration: 1.5).delay(0.5)) {
                        self.scene2TextOpacity = 1
                    }
                }
            }
        }
        
    }
    
    func checkAuthorization() async {
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

    func requestAuthorization() {
        Task {
            await checkAuthorization()
        }
    }
}

#Preview {
    OnBoardingView(isOnBoardingDone: .constant(false))
}
