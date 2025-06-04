//
//  TotalActivityView.swift
//  ScreenTimeReporter
//
//  Created by Yuvraj P on 6/2/25.
//

import SwiftUI

struct TotalActivityView: View {
    let totalActivity: String
    let currentDate = Date()
    let calendar = Calendar.current
    var body: some View {
        GeometryReader { geometry in
                    ZStack {
                        Color(.sRGB, red: 0.99, green: 0.96, blue: 0.94).ignoresSafeArea()
                        
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("42")
                                .font(.system(size: geometry.size.width * 0.29))
                                .fontWeight(.light)
                            
                            Text("%")
                                .font(.system(size: geometry.size.width * 0.07))
                                .fontWeight(.medium)
                                .baselineOffset(geometry.size.width * 0.02)
                            
                            
                        }
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.22)
                        HStack(alignment: .firstTextBaseline, spacing: geometry.size.width * 0.01) {
                            
                            Text(totalActivity).font(.system(size: geometry.size.width * 0.07))
                                .fontWeight(.semibold)
                            Text("spent today").font(.system(size: geometry.size.width * 0.05))
                                .fontWeight(.medium)
                        }.position(x:geometry.size.width / 2, y: geometry.size.height * 0.32)
                        HStack(alignment: .firstTextBaseline, spacing: geometry.size.width * 0.02) {
                            ForEach(0..<7) {
                                index in
                                let dayData = getDayData(for: index)
                                dayCapsule(dayName: dayData.name, dayNumber: dayData.number, isToday: dayData.isToday, geometry: geometry)
                            }
                            
                        }.position(x: geometry.size.width / 2, y: geometry.size.height * 0.73)
                            
                    }
                    
                }
            }

            func dayCapsule(dayName: String, dayNumber: String, isToday: Bool, geometry: GeometryProxy) -> some View {
                ZStack{
                    Capsule().fill(isToday ? Color(.sRGB, red: 0.93, green: 0.89, blue: 0.84) : Color(.sRGB, red: 0.99, green: 0.96, blue: 0.94)).frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.26).cornerRadius(30)
                    VStack{
                        Circle().fill(Color(.sRGB, red: 0.27, green: 0.42, blue: 0.90)).frame(width: geometry.size.width * 0.028, height: geometry.size.width * 0.04)
                        Text(dayName)
                            .font(.system(size: geometry.size.width * 0.044))
                            .fontWeight(.semibold)
                        Text(dayNumber)
                            .font(.system(size: geometry.size.width * 0.06))
                            .fontWeight(.bold)
                    }
                }
            }
            
            func getDayData(for dayIndex: Int) -> (name: String, number: String, isToday: Bool) {
                        let dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                        var currentDateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)
                        currentDateComponents.weekday = 2
                        
                        guard let mondayDate = calendar.date(from: currentDateComponents) else {
                            return (dayNames[dayIndex], "", false)
                        }
                        
                        guard let date = calendar.date(byAdding: .day, value: dayIndex, to: mondayDate) else {
                            return (dayNames[dayIndex], "", false)
                        }
                        
                        let dayNumber = String(calendar.component(.day, from: date))
                        
                        let isToday = calendar.isDate(date, inSameDayAs: currentDate)
                        
                        return (dayNames[dayIndex], dayNumber, isToday)
                }
                    
        }


// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.

