//
//  HomeView.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/5/25.
//
import SwiftUI
import DeviceActivity
import FamilyControls


struct HomeView: View {
    
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
    @State private var isLoading = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.purple)
                    .ignoresSafeArea()
                
                if isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading activity data...")
                            .foregroundColor(.secondary)
                            .padding(.top)
                    }
                }
                
                DeviceActivityReport(homeContext, filter: filter)
                    .opacity(isLoading ? 0 : 1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isLoading = false
                            }
                        }
                    }
            }
            .ignoresSafeArea()
        }
        .onDisappear {
            isLoading = true
        }
    }
}
