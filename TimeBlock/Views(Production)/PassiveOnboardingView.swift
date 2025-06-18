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
    @State private var selectedDays: Set<DayOfWeek> = [.monday, .tuesday, .wednesday, .thursday, .friday]
    @State private var familyActivitySelection = FamilyActivitySelection()
    
    // Section expansion states
    @State private var expandedSection: ExpandableSection? = nil
    
    // Constants
    let backgroundGradient = Gradient(colors: [
        Color(red: 0.682, green: 0.749, blue: 0.627),
        Color(red: 0.894, green: 0.914, blue: 0.796)
    ])
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    gradient: backgroundGradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: adaptiveSpacing(geometry, 20)) {
                        // Header
                        header(geometry: geometry)
                        
                        // Time selection panel
                        expandablePanel(
                            section: .time,
                            icon: "clock.fill",
                            title: "Blocking Time",
                            subtitle: expandedSection == .time ? "" : timeRangeText(),
                            geometry: geometry
                        ) {
                            timeSelectionContent(geometry: geometry)
                        }
                        
                        // Days selection panel
                        expandablePanel(
                            section: .days,
                            icon: "calendar",
                            title: "Active Days",
                            subtitle: expandedSection == .days ? "" : daysText(),
                            geometry: geometry
                        ) {
                            daySelectionContent(geometry: geometry)
                        }
                        
                        // Apps selection panel
                        expandablePanel(
                            section: .apps,
                            icon: "app.badge.fill",
                            title: "Block Apps",
                            subtitle: expandedSection == .apps ? "" : "\(familyActivitySelection.applicationTokens.count) apps selected",
                            geometry: geometry
                        ) {
                            appSelectionContent(geometry: geometry)
                        }
                        
                        // Activate button
                        activateButton(geometry: geometry)
                    }
                    .padding(.horizontal, adaptiveHorizontalPadding(geometry, 20))
                    .padding(.vertical, adaptiveSpacing(geometry, 30))
                }
            }
        }
    }
    
    // MARK: - UI Sections
    @ViewBuilder
    private func header(geometry: GeometryProxy) -> some View {
        VStack(spacing: adaptiveSpacing(geometry, 10)) {
            Text("Let's create a")
                .font(.instrumentR(size: adaptiveFontSize(geometry, 42)))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            Text("Block schedule.")
                .font(.instrumentI(size: adaptiveFontSize(geometry, 48)))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Configure when and what you want to block")
                .font(.instrumentSan(size: adaptiveFontSize(geometry, 16)))
                .foregroundColor(.black.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.top, adaptiveSpacing(geometry, 5))
        }
        .padding(.bottom, adaptiveSpacing(geometry, 15))
    }
    
    @ViewBuilder
    private func expandablePanel<Content: View>(
        section: ExpandableSection,
        icon: String,
        title: String,
        subtitle: String,
        geometry: GeometryProxy,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        let isExpanded = expandedSection == section
        
        VStack(spacing: 0) {
            // Panel header
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    expandedSection = isExpanded ? nil : section
                }
            }) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: adaptiveFontSize(geometry, 18), weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(title)
                        .font(.instrumentSan(size: adaptiveFontSize(geometry, 18)))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.instrumentSan(size: adaptiveFontSize(geometry, 16)))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: adaptiveFontSize(geometry, 16)))
                        .foregroundColor(.black)
                        .padding(.leading, adaptiveHorizontalPadding(geometry, 8))
                }
                .padding(.vertical, adaptiveSpacing(geometry, 16))
                .padding(.horizontal, adaptiveHorizontalPadding(geometry, 15))
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.8))
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                )
            }
            
            // Panel content
            if isExpanded {
                VStack {
                    content()
                }
                .padding(.top, adaptiveSpacing(geometry, 15))
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.bottom, adaptiveSpacing(geometry, 10))
    }
    
    @ViewBuilder
    private func timeSelectionContent(geometry: GeometryProxy) -> some View {
        VStack(spacing: adaptiveSpacing(geometry, 20)) {
            timeSelector(title: "Start Time", selection: $startTime, geometry: geometry)
            timeSelector(title: "End Time", selection: $endTime, geometry: geometry)
            
            Button(action: {
                withAnimation {
                    expandedSection = nil
                }
            }) {
                Text("Done")
                    .font(.instrumentSan(size: adaptiveFontSize(geometry, 16)))
                    .foregroundColor(.white)
                    .padding(.vertical, adaptiveSpacing(geometry, 12))
                    .padding(.horizontal, adaptiveHorizontalPadding(geometry, 40))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black)
                    )
            }
            .padding(.top, adaptiveSpacing(geometry, 10))
        }
    }
    
    @ViewBuilder
    private func daySelectionContent(geometry: GeometryProxy) -> some View {
        VStack(spacing: adaptiveSpacing(geometry, 20)) {
            daySelectionGrid(geometry: geometry)
            
            Button(action: {
                withAnimation {
                    expandedSection = nil
                }
            }) {
                Text("Done")
                    .font(.instrumentSan(size: adaptiveFontSize(geometry, 16)))
                    .foregroundColor(.white)
                    .padding(.vertical, adaptiveSpacing(geometry, 12))
                    .padding(.horizontal, adaptiveHorizontalPadding(geometry, 40))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedDays.isEmpty ? Color.gray : Color.black)
                    )
            }
            .disabled(selectedDays.isEmpty)
            .padding(.top, adaptiveSpacing(geometry, 10))
        }
    }
    
    @ViewBuilder
    private func appSelectionContent(geometry: GeometryProxy) -> some View {
        VStack(spacing: adaptiveSpacing(geometry, 15)) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.85))
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                
                FamilyActivityPicker(selection: $familyActivitySelection)
                    .frame(height: geometry.size.height * 0.35)
                    .clipped()
                    .preferredColorScheme(.dark)
            }
            .frame(height: geometry.size.height * 0.37)
            
            Button(action: {
                withAnimation {
                    expandedSection = nil
                }
            }) {
                Text("Done")
                    .font(.instrumentSan(size: adaptiveFontSize(geometry, 16)))
                    .foregroundColor(.white)
                    .padding(.vertical, adaptiveSpacing(geometry, 12))
                    .padding(.horizontal, adaptiveHorizontalPadding(geometry, 40))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(familyActivitySelection.isEmpty ? Color.gray : Color.black)
                    )
            }
            .disabled(familyActivitySelection.isEmpty)
        }
    }
    
    @ViewBuilder
    private func activateButton(geometry: GeometryProxy) -> some View {
        Button(action: {
            activateSchedule()
            //appState.navigationPath.append("HomeView")
        }) {
            HStack {
                Image(systemName: "play.fill")
                    .font(.system(size: adaptiveFontSize(geometry, 16)))
                
                Text("Activate Schedule")
                    .font(.instrumentSan(size: adaptiveFontSize(geometry, 18)))
            }
            .foregroundColor(.white)
            .padding(.vertical, adaptiveSpacing(geometry, 16))
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isConfigValid() ? Color.black : Color.gray)
            )
        }
        .disabled(!isConfigValid())
        .padding(.top, adaptiveSpacing(geometry, 15))
    }
    
    // MARK: - UI Components
    @ViewBuilder
    private func timeSelector(title: String, selection: Binding<Date>, geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: adaptiveSpacing(geometry, 8)) {
            Text(title)
                .font(.instrumentSan(size: adaptiveFontSize(geometry, 16)))
                .foregroundColor(.black)
            
            DatePicker("", selection: selection, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(height: adaptiveSpacing(geometry, 100))
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.6))
                        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
                )
        }
    }
    
    @ViewBuilder
    private func daySelectionGrid(geometry: GeometryProxy) -> some View {
        VStack(spacing: adaptiveSpacing(geometry, 15)) {
            HStack(spacing: adaptiveSpacing(geometry, 10)) {
                dayButton(.sunday, geometry: geometry)
                dayButton(.monday, geometry: geometry)
                dayButton(.tuesday, geometry: geometry)
            }
            
            HStack(spacing: adaptiveSpacing(geometry, 10)) {
                dayButton(.wednesday, geometry: geometry)
                dayButton(.thursday, geometry: geometry)
                dayButton(.friday, geometry: geometry)
            }
            
            HStack(spacing: adaptiveSpacing(geometry, 10)) {
                dayButton(.saturday, geometry: geometry)
                Spacer()
                    .frame(width: geometry.size.width * 0.15)
                Spacer()
                    .frame(width: geometry.size.width * 0.15)
            }
        }
    }
    
    @ViewBuilder
    private func dayButton(_ day: DayOfWeek, geometry: GeometryProxy) -> some View {
        let isSelected = selectedDays.contains(day)
        let dayName = day.shortName
        
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                if selectedDays.contains(day) {
                    selectedDays.remove(day)
                } else {
                    selectedDays.insert(day)
                }
            }
        }) {
            Text(dayName)
                .font(.instrumentSan(size: adaptiveFontSize(geometry, 15)))
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: geometry.size.width * 0.17, height: adaptiveSpacing(geometry, 45))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.black : Color.white.opacity(0.6))
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
        }
    }
    
    // MARK: - Helper Methods
    private func adaptiveFontSize(_ geometry: GeometryProxy, _ baseFontSize: CGFloat) -> CGFloat {
        let screenWidth = geometry.size.width
        let referenceWidth: CGFloat = 390 // iPhone 13 width
        
        let scaleFactor = min(screenWidth / referenceWidth, 1.1)
        
        let sizeAdjustment: CGFloat = baseFontSize > 40 ? 0.90 : 1
        return max(12, baseFontSize * scaleFactor * sizeAdjustment)
    }
    
    private func adaptiveSpacing(_ geometry: GeometryProxy, _ spacing: CGFloat) -> CGFloat {
        spacing * (geometry.size.height / 844) // Based on iPhone 13 height
    }
    
    private func adaptiveHorizontalPadding(_ geometry: GeometryProxy, _ padding: CGFloat = 20) -> CGFloat {
        padding * (geometry.size.width / 390) // Based on iPhone 13 width
    }
    
    private func timeRangeText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }
    
    private func daysText() -> String {
        if selectedDays.count == 7 {
            return "Every day"
        } else if selectedDays.count >= 5 && selectedDays.contains(.monday) && selectedDays.contains(.friday) {
            return "Weekdays + \(selectedDays.count - 5) more"
        } else {
            return selectedDays.sorted().map { $0.shortName }.joined(separator: ", ")
        }
    }
    
    private func isConfigValid() -> Bool {
        return !selectedDays.isEmpty && !familyActivitySelection.isEmpty
    }
    
    // MARK: - Functionality Methods
    private func activateSchedule() {
        let schedule = BlockSchedule(
            startTime: startTime,
            endTime: endTime,
            activeDays: selectedDays,
            blockedApps: familyActivitySelection
        )
        
        // Save to app state
        //appState.schedules.append(schedule)
        
        // You would then configure DeviceActivity monitoring with this schedule
    }
}

// MARK: - Supporting Types
enum ExpandableSection: String {
    case time, days, apps
}

enum DayOfWeek: Int, CaseIterable, Comparable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    var shortName: String {
        switch self {
        case .sunday: return "Sun"
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        }
    }
    
    static func < (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct BlockSchedule {
    let id = UUID()
    let startTime: Date
    let endTime: Date
    let activeDays: Set<DayOfWeek>
    let blockedApps: FamilyActivitySelection
}

#Preview {
    PassiveOnboardingView()
}
