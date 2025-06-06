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
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.93, green: 0.89, blue: 0.84), Color(red: 0.99, green: 0.96, blue: 0.94)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                VStack {
                    
                    
                    if isAuthorized {
                        HomeView()
                    
                        
                    } else {
                        (Text("We take your privacy very seriously").font(.instrumentR(size: 49))
                            .foregroundColor(.black) + Text(" \n \n we only request permissions needed to help you, and we never collect or share your data.").foregroundColor(.black)).multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer().frame(height: geometry.size.height * 0.1)
                        Button(action: {
                            
                            requestAuthorization()
                            
                            
                        }) {
                            Text("Proceed with Permission")
                                .font(.instrumentSan(size: 20))
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 28)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.black.opacity(1))
                                )
                        }
            
                    }
                    
                    
                    
                }.position(x: geometry.size.width / 2, y: geometry.size.height * 0.5)
            }
        }.onAppear {
            
            requestAuthorization()
        }
    }
    func checkAuthorization() async {
            let center = AuthorizationCenter.shared
            do {
                try await center.requestAuthorization(for: .individual)
                DispatchQueue.main.async {
                    if center.authorizationStatus == .approved {
                        self.isAuthorized = true
                    } else {
                        self.isAuthorized = false

                        print("Authorization not approved. Status: \(center.authorizationStatus.rawValue)")
                    }
                }
            } catch {
                print("Failed to request authorization: \(error)")
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
