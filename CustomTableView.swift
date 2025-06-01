import SwiftUI
import CoreLocation

struct CustomTabView: View {
    @Binding var isAuthenticated: Bool
    @State private var selectedTab = 0
    @State private var selectedCoordinate: IdentifiableCoordinate? = nil
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // Main content
            Group {
                switch selectedTab {
                case 0:
                    HomeView(selectedCoordinate: $selectedCoordinate, isAuthenticated: $isAuthenticated)
                case 1:
                    MapViewContent()
                case 2:
                    ChatView()
                case 3:
                    ProfileView(isAuthenticated: $isAuthenticated)
                default:
                    EmptyView()
                }
            }
            
            // Custom Tab Bar
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    TabBarButton(
                        icon: "house.fill",
                        label: "Home",
                        isSelected: selectedTab == 0,
                        action: { selectedTab = 0 }
                    )
                    
                    TabBarButton(
                        icon: "map.fill",
                        label: "Map",
                        isSelected: selectedTab == 1,
                        action: { selectedTab = 1 }
                    )
                    
                    TabBarButton(
                        icon: "message.fill",
                        label: "Messages",
                        isSelected: selectedTab == 2,
                        action: { selectedTab = 2 }
                    )
                    
                    TabBarButton(
                        icon: "person.crop.circle.fill",
                        label: "Profile",
                        isSelected: selectedTab == 3,
                        action: { selectedTab = 3 }
                    )
                }
                .background(
                    ModernColorScheme.surface
                        .opacity(0.95)
                        .blur(radius: 10)
                )
                .clipShape(Capsule())
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                .shadow(color: ModernColorScheme.primary.opacity(0.2), radius: 10, x: 0, y: 5)
            }
        }
        .background(ModernColorScheme.background)
        .accentColor(ModernColorScheme.primary)
        .onAppear {
            isAnimating = true
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? ModernColorScheme.primary : ModernColorScheme.textSecondary)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(label)
                    .font(ModernFontScheme.caption)
                    .foregroundColor(isSelected ? ModernColorScheme.primary : ModernColorScheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(isAuthenticated: .constant(true))
    }
}
