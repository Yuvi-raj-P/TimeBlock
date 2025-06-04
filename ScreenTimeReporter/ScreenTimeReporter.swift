//
//  ScreenTimeReporter.swift
//  ScreenTimeReporter
//
//  Created by Yuvraj P on 6/2/25.
//

import DeviceActivity
import SwiftUI

@main
struct ScreenTimeReporter: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            return TotalActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
    }
}
