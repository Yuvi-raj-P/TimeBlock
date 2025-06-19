import SwiftUI
import DeviceActivity
import FamilyControls
import ManagedSettings

struct PermissionsView: View {
    // MARK: - Properties
    @EnvironmentObject var appState: AppStateViewModel
    
    // State management
    @State private var currentScene: Int = 0 // 0 = initial, 1 = sparkle animation, 2 = final
    @State private var isAuthorized: Bool = true
    @State private var pickerDismissedWithoutSelection = false
    @State private var familyActivitySelection = FamilyActivitySelection()
    @State private var showPickerInline: Bool = false
    @State private var sparkles: [Sparkle] = []
    @State private var navigateToHome: Bool = false
    
    // Persistent storage
    @AppStorage("isAppsSelected") private var isAppsSelected: Bool = false
    @AppStorage("isUninstallLock") private var isUninstallLock: Bool = false
    
    // Constants
    let store = ManagedSettingsStore()
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
                .opacity(currentScene == 2 ? 0 : 1)
                
                if navigateToHome {
                    HomeView()
                } else {
                    renderCurrentScene(geometry: geometry)
                }
            }
            .ignoresSafeArea()
            .onAppear {
                if !isAuthorized {
                    requestAuthorization()
                }
            }
        }
    }
    
    // MARK: - Scene Rendering
    @ViewBuilder
    private func renderCurrentScene(geometry: GeometryProxy) -> some View {
        switch currentScene {
        case 0:
            initialScene(geometry: geometry)
        case 1:
            animationScene(geometry: geometry)
        case 2:
            finalScene(geometry: geometry)
        default:
            EmptyView()
        }
    }
    
    // MARK: - Scene Implementations
    @ViewBuilder
    private func initialScene(geometry: GeometryProxy) -> some View {
        if isAuthorized {
            if !isAppsSelected {
                appSelectionScene(geometry: geometry)
            } else {
                Color.clear.onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.currentScene = 2
                    }
                }
            }
        } else {
            permissionRequestScene(geometry: geometry)
        }
    }
    
    @ViewBuilder
    private func appSelectionScene(geometry: GeometryProxy) -> some View {
        if showPickerInline {
            appPickerView(geometry: geometry)
        } else {
            appSelectionPrompt(geometry: geometry)
        }
    }
    
    @ViewBuilder
    private func appPickerView(geometry: GeometryProxy) -> some View {
        VStack(spacing: adaptiveSpacing(geometry, 15)) {
            titleText(geometry: geometry)
            
            Text("Choose at least one now — you can always come back to it.")
                .font(.instrumentSan(size: adaptiveFontSize(geometry, 16)))
                .foregroundColor(pickerDismissedWithoutSelection ? .black : .black.opacity(0.5))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding(.horizontal)
            
            pickerContainer(geometry: geometry)
            Spacer().frame(height: adaptiveSpacing(geometry, 20))
            proceedButton(geometry: geometry)
        }
        .frame(width: geometry.size.width)
        .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.6)
    }
    
    @ViewBuilder
    private func appSelectionPrompt(geometry: GeometryProxy) -> some View {
        VStack() {
            Text("Pick your")
                .font(.instrumentR(size: adaptiveFontSize(geometry, 60)))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            Text("time-thieves.")
                .font(.instrumentI(size: adaptiveFontSize(geometry, 64)))
                .foregroundColor(.white)
            Spacer().frame(height: adaptiveSpacing(geometry, 10))
            Text(pickerDismissedWithoutSelection
                 ? "Please select at least 1 app to continue"
                 : "We'll help you stay aware — nothing's locked, everything's adjustable later.")
                .font(.instrumentSan(size: adaptiveFontSize(geometry, 16)))
                .foregroundColor(pickerDismissedWithoutSelection ? .black : .black.opacity(0.5))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding(.horizontal, adaptiveHorizontalPadding(geometry))
            
            Spacer()
                .frame(height: adaptiveSpacing(geometry, 140))
            
            selectAppsButton(geometry: geometry)
        }
        .frame(width: geometry.size.width)
        .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.66)
    }
    
    @ViewBuilder
    private func permissionRequestScene(geometry: GeometryProxy) -> some View {
        VStack(spacing: adaptiveSpacing(geometry, 20)) {
            Text("We take your privacy very seriously")
                .font(.instrumentR(size: adaptiveFontSize(geometry, 52)))
                .foregroundColor(.black).multilineTextAlignment(.center)
             Text("We only request permissions needed to help you, and we never collect or share your data.")
                .font(.instrumentSan(size: adaptiveFontSize(geometry, 16)))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, adaptiveHorizontalPadding(geometry))
            
            Spacer()
                .frame(height: adaptiveSpacing(geometry, 80))
            
            Button(action: {
                requestAuthorization()
            }) {
                Text("Proceed with Permission")
                    .font(.instrumentSan(size: adaptiveFontSize(geometry, 18)))
                    .foregroundColor(.white)
                    .padding(.vertical, adaptiveSpacing(geometry, 15))
                    .padding(.horizontal, adaptiveHorizontalPadding(geometry, 28))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black)
                    )
            }
        }
        .frame(width: geometry.size.width)
        .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.63)
    }
    
    @ViewBuilder
    private func animationScene(geometry: GeometryProxy) -> some View {
        ZStack {
            VStack(spacing: adaptiveSpacing(geometry, 10)) {
                Text("Well picked!")
                    .font(.instrumentI(size: adaptiveFontSize(geometry, 64)))
                    .foregroundColor(.black.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .zIndex(1)
                
                Text("Let's keep you focused.")
                    .font(.instrumentR(size: adaptiveFontSize(geometry, 64)))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(width: geometry.size.width)
            
            ForEach(sparkles) { sparkle in
                PulseStarViewa(sparkle: sparkle)
            }
        }
        .onAppear {
            pulseBurst()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.currentScene = 2
                }
            }
        }
        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
    }
    
    @ViewBuilder
    private func finalScene(geometry: GeometryProxy) -> some View {
        ZStack {
            LinearGradient(
                gradient: backgroundGradient,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: adaptiveSpacing(geometry, 30)) {
                (Text("Refrain ")
                    .font(.instrumentI(size: adaptiveFontSize(geometry, 48)))
                    .foregroundColor(.white) +
                 Text("yourself \n from uninstalling.")
                    .font(.instrumentR(size: adaptiveFontSize(geometry, 48)))
                    .foregroundColor(.black)
                )
                .multilineTextAlignment(.center)
                .padding(.horizontal, adaptiveHorizontalPadding(geometry))
                
                Text("Uninstall Protection stops you from uninstalling the app during block sessions, you can change this later.")
                    .font(.instrumentSan(size: adaptiveFontSize(geometry, 16)))
                    .foregroundColor(.black.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, adaptiveHorizontalPadding(geometry, 15))
                
                Spacer()
                    .frame(height: adaptiveSpacing(geometry, 20))
                
                Button(action: {
                    appState.isUninstallProtectionEnabled = true
                    appState.markPermissionsGranted()
                }) {
                    Text("Turn on")
                        .font(.instrumentSan(size: adaptiveFontSize(geometry, 20)))
                        .foregroundColor(.white)
                        .padding(.vertical, adaptiveSpacing(geometry, 15))
                        .padding(.horizontal, adaptiveHorizontalPadding(geometry, 48))
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black)
                        )
                }
                
                Button(action: {
                    appState.isUninstallProtectionEnabled = false
                    appState.markPermissionsGranted()
                }) {
                    Text("No Thanks")
                        .font(.instrumentSan(size: adaptiveFontSize(geometry, 20)))
                        .foregroundColor(.black)
                        .padding(.vertical, adaptiveSpacing(geometry, 15))
                        .padding(.horizontal, adaptiveHorizontalPadding(geometry, 40))
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                        )
                }
            }
            .frame(width: geometry.size.width)
            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.6)
        }
    }
    
    // MARK: - UI Components
    @ViewBuilder
    private func titleText(geometry: GeometryProxy) -> some View {
        (Text("What's stealing your ")
            .font(.instrumentR(size: adaptiveFontSize(geometry, 50)))
            .foregroundColor(.black) +
         Text("time?")
            .font(.instrumentI(size: adaptiveFontSize(geometry, 50)))
            .foregroundColor(.white)
        )
        .multilineTextAlignment(.center)
        .padding(.horizontal, adaptiveHorizontalPadding(geometry))
    }
    
    @ViewBuilder
    private func pickerContainer(geometry: GeometryProxy) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.85))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
            
            FamilyActivityPicker(selection: $familyActivitySelection)
                .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.45)
                .clipped()
                .preferredColorScheme(.dark)
        }
        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.48)
        .padding(.horizontal, 5)
    }
    
    @ViewBuilder
    private func proceedButton(geometry: GeometryProxy) -> some View {
        Button(action: {
            if !familyActivitySelection.isEmpty {
                self.isAppsSelected = true
                self.pickerDismissedWithoutSelection = false
                withAnimation {
                    self.showPickerInline = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.currentScene = 1
                    }
                }
            }
        }) {
            Text("Proceed")
                .font(.system(size: adaptiveFontSize(geometry, 18), weight: .medium))
                .foregroundColor(.white)
                .padding(.vertical, adaptiveSpacing(geometry, 12))
                .padding(.horizontal, adaptiveHorizontalPadding(geometry, 50))
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(familyActivitySelection.isEmpty ? 0.6 : 1.0))
                )
        }
        .disabled(familyActivitySelection.isEmpty)
    }
    
    @ViewBuilder
    private func selectAppsButton(geometry: GeometryProxy) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                self.showPickerInline = true
            }
            self.pickerDismissedWithoutSelection = false
        }) {
            Text("Select Apps")
                .font(.system(size: adaptiveFontSize(geometry, 18), weight: .medium))
                .foregroundColor(.white)
                .padding(.vertical, adaptiveSpacing(geometry, 12))
                .padding(.horizontal, adaptiveHorizontalPadding(geometry, 50))
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black)
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
        spacing * (geometry.size.height / 844) // Base on iPhone 13 height
    }
    
    private func adaptiveHorizontalPadding(_ geometry: GeometryProxy, _ padding: CGFloat = 20) -> CGFloat {
        padding * (geometry.size.width / 390) // Base on iPhone 13 width
    }
    
    // MARK: - Functionality Methods
    
    func checkAuthorization() async {
        let center = AuthorizationCenter.shared
        if center.authorizationStatus == .approved {
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
            return
        }
        
        do {
            try await center.requestAuthorization(for: .individual)
            DispatchQueue.main.async {
                self.isAuthorized = center.authorizationStatus == .approved
                if !self.isAuthorized {
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
    
    func pulseBurst() {
        sparkles.removeAll()
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for i in 0..<100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.025) {
                let sparkle = Sparkle(
                    id: UUID(),
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight),
                    size: CGFloat.random(in: 20...60),
                    rotation: Double.random(in: 0...360)
                )
                sparkles.append(sparkle)
            }
        }
    }
}

// MARK: - Supporting Types
struct Sparkle: Identifiable {
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
        path.addLine(to: CGPoint(x: midX + size / 2, y: midY))
        path.addLine(to: CGPoint(x: midX + size / 10, y: midY + size / 10))
        path.addLine(to: CGPoint(x: midX, y: midY + size / 2))
        path.addLine(to: CGPoint(x: midX - size / 10, y: midY + size / 10))
        path.addLine(to: CGPoint(x: midX - size / 2, y: midY))
        path.addLine(to: CGPoint(x: midX - size / 10, y: midY - size / 10))
        path.closeSubpath()
        
        return path
    }
}

struct PulseStarViewa: View {
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
            .shadow(color: .white.opacity(0.7), radius: sparkle.size / 5)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4)) {
                    scale = 1.2
                }
                withAnimation(.easeInOut(duration: 1.2).delay(0.4)) {
                    scale = 1.0
                }
                withAnimation(.easeInOut(duration: 1.0).delay(1.5)) {
                    opacity = 0
                }
            }
    }
}

#Preview {
    PermissionsView()
}
