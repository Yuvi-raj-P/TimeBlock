//
//  PassiveOnboardingView.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/17/25.
//

import SwiftUI
import FamilyControls
import DeviceActivity

struct PassiveOnboardingView: View {
    // MARK: - Properties
    @EnvironmentObject var appState: AppStateViewModel
    
    // State management
    @State private var startTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var endTime: Date = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var familyActivitySelection = FamilyActivitySelection()
    @State private var scheduleName: String = ""
    @State private var selectedDays: Set<String> = ["Mo", "Tu", "We", "Th", "Fr"]
    @State private var isActivityPickerPresented = false
    
    // Constants
    let backgroundGradient = Gradient(colors: [
        Color(red: 0.682, green: 0.749, blue: 0.627),
        Color(red: 0.894, green: 0.914, blue: 0.796)
    ])
    let daysOfWeek = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    
    private var isFormValid: Bool {
            !scheduleName.isEmpty &&
            !selectedDays.isEmpty &&
            !(familyActivitySelection.applicationTokens.isEmpty &&
              familyActivitySelection.categoryTokens.isEmpty &&
              familyActivitySelection.webDomainTokens.isEmpty)
        }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: backgroundGradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    (Text("Let's create a").font(.instrumentR(size: 50))
                        .foregroundColor(.black) + Text("\nBlock Schedule.").font(.instrumentI(size: 50))).multilineTextAlignment(.center)
                        .padding(.top)
                    
                    Text("Schedules help build healthy habits. You can \n always change them later.")
                        .font(.instrumentSan(size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black).opacity(0.8)
                    
                    TextField("Schedule Name", text: $scheduleName, prompt: Text("My Block Schedule #1").font(.instrumentSan(size: 18)).foregroundColor(.black.opacity(0.6)))
                        .padding()
                        .tint(.black)
                        .foregroundColor(.black)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                        .font(.instrumentSan(size: 16))
                        .padding(.top)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 16) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 20, height: 20)
                            Text("Start time:")
                                .font(.instrumentSan(size: 17))
                                .foregroundColor(.black)
                            Spacer()
                            DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .tint(.black)
                        }
                        HStack {
                            Path { path in
                                path.move(to: CGPoint(x: 10, y: 0))
                                path.addLine(to: CGPoint(x: 10, y: 40))
                            }
                            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: [6]))
                            .foregroundColor(.white)
                            .frame(width: 20, height: 40)
                            
                            Spacer()
                        }
                        .padding(.leading, 0)
                        
                        HStack(spacing: 16) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 20, height: 20)
                            Text("End time:")
                                .font(.instrumentSan(size: 17))
                                .foregroundColor(.black)
                            Spacer()
                            DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .tint(.black)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    
                    Text("Active Days")
                        .font(.instrumentSan(size: 18))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40)
                    
                    HStack(spacing: 10) {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Button(action: {
                                if selectedDays.contains(day) {
                                    selectedDays.remove(day)
                                } else {
                                    selectedDays.insert(day)
                                }
                            }) {
                                Text(day)
                                    .font(.instrumentSan(size: 14))
                                    .fontWeight(.bold)
                                    .foregroundColor(selectedDays.contains(day) ? .white : .black)
                                    .frame(width: 40, height: 40)
                                    .background(selectedDays.contains(day) ? Color.black.opacity(0.7) : Color.white.opacity(0.8))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                   
                    
                    Button(action: {
                        isActivityPickerPresented = true
                    }) {
                        HStack {
                            Text(familyActivitySelection.applicationTokens.isEmpty && familyActivitySelection.categoryTokens.isEmpty && familyActivitySelection.webDomainTokens.isEmpty ? "Select Apps to Block" : "Edit App Selection")
                                .font(.instrumentSan(size: 16))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black.opacity(0.6))
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    
                    
                    Button(action: {
                        let weekdays = selectedDays.compactMap { Weekday(shortName: $0) }
                        let schedule = BlockSchedule(
                            name: scheduleName,
                            startTime: startTime,
                            endTime: endTime,
                            activeDays: weekdays,
                            selection: familyActivitySelection
                        )
                        appState.saveBlockSchedule(schedule: schedule)
                        appState.activateBlockSchedule(schedule: schedule)
                        appState.markOnboardingCompleted()
                    }) {
                        Text("Activate Schedule")
                            .font(.instrumentSan(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: 150)
                            .padding()
                            .background(isFormValid ? Color.black : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isFormValid)
                    
                }
                .familyActivityPicker(isPresented: $isActivityPickerPresented, selection: $familyActivitySelection)
                
                
            }
        }
    }
}

#Preview {
    PassiveOnboardingView()
        .environmentObject(AppStateViewModel())
}
