//
//  BlockSchedule.swift
//  TimeBlock
//
//  Created by Yuvraj P on 6/18/25.
//

import Foundation
import FamilyControls

struct BlockSchedule: Codable {
    var name: String
    var startTime: Date
    var endTime: Date
    var activeDays: [Weekday]
    var selection: FamilyActivitySelection
}
enum Weekday: String, Codable, CaseIterable, Identifiable{
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    var id: String {rawValue}

    init?(shortName: String) {
        switch shortName {
        case "Su": self = .sunday
        case "Mo": self = .monday
        case "Tu": self = .tuesday
        case "We": self = .wednesday
        case "Th": self = .thursday
        case "Fr": self = .friday
        case "Sa": self = .saturday
        default: return nil
        }
    }
}
