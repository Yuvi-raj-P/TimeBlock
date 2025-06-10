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
    @State private var isAuthorized: Bool = true
    
    private var isPreview: Bool {
            return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        }
    @State private var isShowingActivityPicker = false
    @State private var selection = FamilyActivitySelection()
    @State private var showPrewarmedReport = false
    @State private var navigateToHomeView = false
    @State private var pickerDismissedWithoutSelection = false
    @Binding var isAppsSelected: Bool
    @State private var sparkles: [Sparkle] = []
    @State private var showCongrats = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: isAuthorized ? [Color(red: 0.682, green: 0.749, blue: 0.627), Color(red: 0.894, green: 0.914, blue: 0.796)] : [Color(red: 0.93, green: 0.89, blue: 0.84), Color(red: 0.99, green: 0.96, blue: 0.94)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                if showCongrats {
                    ZStack {
                        
                        VStack{
                            Text("Well picked!")
                                .font(.instrumentI(size: 64))
                                .foregroundColor(.black.opacity(0.6))
                                .zIndex(1)
                            Text("Let’s keep you focused.")
                                .font(.instrumentR(size: 64))
                                .foregroundColor(.white)
                        }
                        

                        ForEach(sparkles) { sparkle in
                            PulseStarView(sparkle: sparkle)
                        }
                    }
                    .onAppear {
                        pulseBurst()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                            withAnimation {
                                showCongrats = false
                                isAppsSelected = true
                            }
                        }
                    }
                    .transition(.opacity)
                }
                else{
                    if isAuthorized {
                        if isAppsSelected == false {
                            VStack {
                                (Text("Pick your")
                                    .font(.instrumentR(size: 60))
                                    .foregroundColor(.black)
                                )
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                
                                Text("time-thieves.")
                                    .font(.instrumentR(size: 64))
                                    .foregroundColor(.white)
                                
                                Spacer().frame(height: geometry.size.height * 0.03)
                               
                                Text(pickerDismissedWithoutSelection ? "Please select at least 1 app to continue" : "We'll help you stay aware — nothing's locked, everything's adjustable later.")
                                    .font(.instrumentSan(size: 18))
                                    .foregroundColor(pickerDismissedWithoutSelection ? .black.opacity(1) : .black.opacity(0.5))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .padding(.horizontal)
                            }
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.4)

                            Button(action: {
                                isShowingActivityPicker = true
                            }) {
                                Text("Select Apps")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.black.opacity(1))
                                    )
                            }
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.89)
                        }
                        else{
                            HomeView()
                        }
                        
                    } else {
                        
                        VStack {
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
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.5)
                    }
                }
            }
        }
        .familyActivityPicker(isPresented: $isShowingActivityPicker, selection: $selection)
        .onChange(of: isShowingActivityPicker) { newValue in
            if !newValue {
                if selection.applicationTokens.isEmpty && selection.categoryTokens.isEmpty && selection.webDomainTokens.isEmpty {
                    pickerDismissedWithoutSelection = true
                } else {
                    pickerDismissedWithoutSelection = false
                    

                    withAnimation {
                        showCongrats = true
                    }
                }
            }
        }
        .onAppear {
            if !isPreview {
                requestAuthorization()
            }
        }
    }
    
    func pulseBurst() {
        sparkles.removeAll()
        for i in 0..<120 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.03) {
                let sparkle = Sparkle(
                    id: UUID(),
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                    size: CGFloat.random(in: 30...80),
                    rotation: Double.random(in: 0...360)
                )
                sparkles.append(sparkle)

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    sparkles.removeAll { $0.id == sparkle.id }
                }
            }
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

struct PulseStarView: View {
    let sparkle: Sparkle
    @State private var scale: CGFloat = 0.01
    @State private var opacity: Double = 1.0

    var body: some View {
        FourPointStar()
            .fill(Color.white)
            .frame(width: sparkle.size, height: sparkle.size)
            .position(x: sparkle.x, y: sparkle.y)
            .scaleEffect(scale)
            .opacity(opacity)
            .rotationEffect(.degrees(sparkle.rotation))
            .shadow(color: .white.opacity(0.9), radius: sparkle.size / 6)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4)) {
                    scale = 1.2
                }
                withAnimation(.easeInOut(duration: 1.2).delay(0.4)) {
                    scale = 1.0
                    opacity = 0
                }
            }
    }
}
/**struct Sparkle: Identifiable {
    let id: UUID
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let rotation: Double
}
struct FourPointStar: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = rect.midX
        let midY = rect.midY
        let size = min(rect.width, rect.height)

        path.move(to: CGPoint(x: midX, y: midY - size / 2))
        path.addLine(to: CGPoint(x: midX + size / 10, y: midY - size / 10))

        path.addLine(to: CGPoint(x: midX + size / 2, y: midY)) // Right
        path.addLine(to: CGPoint(x: midX + size / 10, y: midY + size / 10))

        path.addLine(to: CGPoint(x: midX, y: midY + size / 2)) // Bottom
        path.addLine(to: CGPoint(x: midX - size / 10, y: midY + size / 10))

        path.addLine(to: CGPoint(x: midX - size / 2, y: midY)) // Left
        path.addLine(to: CGPoint(x: midX - size / 10, y: midY - size / 10))

        path.closeSubpath()
        return path
    }
}**/

#Preview {
    ContentView(isAppsSelected: .constant(false))
}
