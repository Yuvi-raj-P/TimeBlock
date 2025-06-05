//
//  OnBoarding.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/3/25.
//

import SwiftUI

struct OnBoardingView: View {
    @Binding var isOnBoardingDone: Bool
    @State private var arrowOffsetY: CGFloat = 0
    @State private var textOpacity: Double = 0
    @State private var currentScene: Int = 0
    @State private var scene2TextOpacity: Double = 0
    
    let scene0Gradient = Gradient(colors: [Color(red: 0.8, green: 0.706, blue: 0.91), Color(red: 0.988, green: 0.937, blue: 0.933)])
    let scene1Gradient = Gradient(colors: [Color(red: 0.655, green: 0.733, blue: 0.78), Color(red: 0.89, green: 0.918, blue: 0.945)])

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                LinearGradient(
                    gradient: currentScene == 0 ? scene0Gradient : scene1Gradient,
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
                        
                        Text("One scroll becomes an hour.").font(.instrumentR(size: 48)).foregroundColor(.black).multilineTextAlignment(.center)
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
                    }.position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.89).onAppear {
                        self.arrowOffsetY = -10
                    }.onAppear {
                        self.textOpacity = 1
                    }.gesture(
                        DragGesture().onEnded { value in
                            
                            if value.translation.height < -50 && currentScene == 0 {
                                withAnimation(.easeInOut(duration: 0.7)) {
                                    textOpacity = 0
                                }
                          
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.easeInOut(duration: 0.7)) {
                                        currentScene = 1
                                    }
                                }
                            }
                        }
                    )
                    
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
                            Text("It leaves us tired and behind on what really matters.").font(.instrumentSan(size: 13)).foregroundColor(.black).multilineTextAlignment(.center)
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
                        }.position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.89).onAppear {
                            self.arrowOffsetY = -10
                        }.onAppear {
                            withAnimation(Animation.easeIn(duration: 1.5).delay(0.5)) {
                                                        self.scene2TextOpacity = 1
                                                    }
                        }.gesture(
                            DragGesture().onEnded { value in
                                
                                if value.translation.height < -50 && currentScene == 0 {
                                    withAnimation(.easeInOut(duration: 0.7)) {
                                        textOpacity = 0
                                    }
                              
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation(.easeInOut(duration: 0.7)) {
                                            currentScene = 1
                                        }
                                    }
                                }
                            }
                        )

                }
            }
            .onChange(of: currentScene) { oldScene, newScene in
                            
                            arrowOffsetY = 0
                        }
        }
    }
}

#Preview {
    OnBoardingView(isOnBoardingDone: .constant(false))
}
