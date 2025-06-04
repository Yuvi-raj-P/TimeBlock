import SwiftUI
import DeviceActivity
import FamilyControls


struct ContentView: View {
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
    @State private var isAuthorized: Bool = false
    var body: some View {
        VStack {
            
            
            if isAuthorized {
                            DeviceActivityReport(homeContext, filter: filter)
                        } else {
                            Text("Screen Time access not authorized. Please grant permission.")
                            Button("Request Permission") {
                                requestAuthorization()
                            }
                        }

            Spacer()
        
        }.onAppear {
            // Check authorization status when the view appears
            Task {
                await checkAuthorization()
            }
        }
    }
    func checkAuthorization() async {
            let center = AuthorizationCenter.shared
            do {
                try await center.requestAuthorization(for: .individual)
                // If no error, authorization was granted or already existed
                DispatchQueue.main.async {
                    self.isAuthorized = true
                }
            } catch {
                // Handle the error (e.g., user denied permission)
                print("Failed to get authorization: \(error)")
                DispatchQueue.main.async {
                    self.isAuthorized = false
                }
            }
        }

        func requestAuthorization() {
            Task {
                await checkAuthorization()
            }
        }

            
}

#Preview {
    ContentView()
}
