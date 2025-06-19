//
//  ScheduleManager.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/18/25.
//
import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls

class ScheduleManager {
   static let shared = ScheduleManager()
   let store = ManagedSettingsStore()
   let center = DeviceActivityCenter()
    
    private var allActivityNames: [DeviceActivityName] {
        Weekday.allCases.map {
            day in DeviceActivityName("com.yuvi-raj-p.TimeBlock.\(day.rawValue)")
        }
    }
    func activateSchedule(schedule: BlockSchedule) {
            // 1. Configure ManagedSettings to shield the selected apps and prevent app removal.
            // This configuration applies whenever any of the monitored activities are active.
            store.shield.applications = schedule.selection.applicationTokens.isEmpty ? nil : schedule.selection.applicationTokens
            store.shield.applicationCategories = schedule.selection.categoryTokens.isEmpty ? nil : .specific(schedule.selection.categoryTokens)
            store.shield.webDomains = schedule.selection.webDomainTokens.isEmpty ? nil : schedule.selection.webDomainTokens
            store.application.denyAppRemoval = true

            // 2. Define the event that will be triggered when a schedule is active.
            let event = DeviceActivityEvent(
                applications: schedule.selection.applicationTokens,
                categories: schedule.selection.categoryTokens,
                webDomains: schedule.selection.webDomainTokens,
                threshold: DateComponents(second: 1) // Trigger event almost immediately after the interval starts.
            )

            // 3. Stop any existing monitoring to replace it with the new schedule.
            center.stopMonitoring(allActivityNames)

            // 4. Create and start monitoring a new schedule for each active day.
            for day in schedule.activeDays {
                let activityName = DeviceActivityName("com.yuvi-raj-p.TimeBlock.\(day.rawValue)")
                
                var startComponents = Calendar.current.dateComponents([.hour, .minute], from: schedule.startTime)
                var endComponents = Calendar.current.dateComponents([.hour, .minute], from: schedule.endTime)
                
                // Map our Weekday enum to the calendar's weekday integer (Sunday=1, etc.).
                if let weekdayInt = Weekday.allCases.firstIndex(of: day) {
                    startComponents.weekday = weekdayInt + 1
                    endComponents.weekday = weekdayInt + 1
                }
                
                // Create a schedule for this specific day of the week that repeats weekly.
                let dailySchedule = DeviceActivitySchedule(
                    intervalStart: startComponents,
                    intervalEnd: endComponents,
                    repeats: true
                )
                
                // Start monitoring for this day's schedule.
                do {
                    try center.startMonitoring(
                        activityName,
                        during: dailySchedule,
                        events: [.timeBlock: event]
                    )
                } catch {
                    print("Error starting monitoring for \(day.rawValue): \(error)")
                }
            }
        }
    
    
}
extension DeviceActivityEvent.Name {
    static let timeBlock = Self("timeBlock")
}
