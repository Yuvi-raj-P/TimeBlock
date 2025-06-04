//
//  OnBoarding.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/3/25.
//

import SwiftUI

struct OnBoardingView: View {
    @Binding var isOnBoardingDone: Bool
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.596, green: 0.365, blue: 0.137), Color(red: 0.988, green: 0.788, blue: 0.584)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                VStack {
                    HStack{
                        Text("Time").font(.instrumentR(size: 55)).foregroundColor(.white)
                        Text("flies:").font(.instrumentI(size: 55))
                        
                    }
                    Text("One scroll becomes an hour.").font(.instrumentR(size: 48)).foregroundColor(.white).multilineTextAlignment(.center)
                    
                    Spacer().frame(height: geometry.size.height * 0.4)
                    
                    

                }
                VStack{
                    Image("ArrowUp")
                    Text("Swipe up").font(.instrumentSan(size: 20)).foregroundColor(.white).multilineTextAlignment(.center)
                }.position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.85)
            }
        }
    }
}

#Preview {
    OnBoardingView(isOnBoardingDone: .constant(false))
}

