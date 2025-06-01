import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabAction: (Int) -> Void
    
    // Add haptic feedback generator
    let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "house.fill",
                label: "Home",
                isSelected: selectedTab == 0,
                action: {
                    hapticFeedback.impactOccurred()
                    tabAction(0)
                }
            )
            TabBarButton(
                icon: "map.fill",
                label: "Map",
                isSelected: selectedTab == 1,
                action: {
                    hapticFeedback.impactOccurred()
                    tabAction(1)
                }
            )
            TabBarButton(
                icon: "message.fill",
                label: "Chat",
                isSelected: selectedTab == 2,
                action: {
                    hapticFeedback.impactOccurred()
                    tabAction(2)
                }
            )
            TabBarButton(
                icon: "person.fill",
                label: "Profile",
                isSelected: selectedTab == 3,
                action: {
                    hapticFeedback.impactOccurred()
                    tabAction(3)
                }
            )
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ModernColorScheme.surface)
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: -2)
        )
        .padding(.horizontal)
    }
}

// TabBarButton is already defined in CustomTableView.swift

// Make IdentifiableCoordinate conform to Equatable for onChange handler
extension IdentifiableCoordinate: Equatable {
    static func == (lhs: IdentifiableCoordinate, rhs: IdentifiableCoordinate) -> Bool {
        return lhs.id == rhs.id &&
               lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showTabBar = false  // Start with tab bar hidden
    @State private var selectedCoordinate: IdentifiableCoordinate?
    @Binding var isAuthenticated: Bool
    @State private var hideTimer: Timer?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(selectedCoordinate: $selectedCoordinate, isAuthenticated: $isAuthenticated)
                    .tag(0)
                    .onTapGesture {
                        showTabBarWithTimer()
                    }
                MapViewContent()
                    .tag(1)
                    .onTapGesture {
                        showTabBarWithTimer()
                    }
                ChatView()
                    .tag(2)
                    .onTapGesture {
                        showTabBarWithTimer()
                    }
                ProfileView(isAuthenticated: $isAuthenticated)
                    .tag(3)
                    .onTapGesture {
                        showTabBarWithTimer()
                    }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: selectedCoordinate) { _, newValue in
                if newValue != nil {
                    selectedTab = 1 // Switch to Map tab when a coordinate is selected
                }
            }
            
            if showTabBar {
                CustomTabBar(selectedTab: $selectedTab) { tabIndex in
                    selectedTab = tabIndex
                    showTabBarWithTimer()
                }
                .padding(.bottom, 10)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .gesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .global)
                .onEnded { value in
                    // Show tab bar when user swipes up from bottom
                    if value.translation.height < 0 && value.location.y > UIScreen.main.bounds.height - 100 {
                        showTabBarWithTimer()
                    }
                }
        )
    }
    
    private func showTabBarWithTimer() {
        // Cancel any existing timer
        hideTimer?.invalidate()
        withAnimation {
            showTabBar = true
        }
        // Start new timer to hide after 2 seconds
        hideTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            withAnimation {
                showTabBar = false
            }
        }
    }
}
