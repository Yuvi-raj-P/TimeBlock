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
        VStack {
            Text("Welcome to TimeBlock!")
            Button("Get Started"){
                isOnBoardingDone = true
            }
            
            
        }
    }
}

#Preview {
    OnBoardingView(isOnBoardingDone: .constant(false))
}

