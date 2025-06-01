import SwiftUI
import UIKit  // Added UIKit for UIImage

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isEditingProfile = false
    @State private var showSettings = false
    @State private var showLogoutAlert = false
    @State private var isAnimating = false
    @Binding var isAuthenticated: Bool
    
    // User data
    @State private var userName = "Adam Bizios"
    @State private var userBio = "Toronto basketball player | Point Guard"
    @State private var userLocation = "Toronto, ON"
    @State private var userRating = 4.7
    @State private var gamesPlayed = 87
    @State private var gamesWon = 52
    @State private var winRate = "60%"
    
    // Favorite courts and recent activity
    @State private var favoriteCourts = [
        "Earl Haig Secondary School",
        "Newtonbrook Secondary School",
        "Georges Vanier Secondary School"
    ]
    
    @State private var recentActivity = [
        RecentActivity(court: "Earl Haig Secondary School", date: "Yesterday", type: "Played Game", result: "Won"),
        RecentActivity(court: "Newtonbrook Secondary School", date: "3 days ago", type: "Joined Chat", result: ""),
        RecentActivity(court: "Don Mills Collegiate Institute", date: "1 week ago", type: "Played Game", result: "Lost")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Profile Header
                    VStack(spacing: 15) {
                        // Profile Image
                        ZStack {
                            Image("profile_placeholder") // Add this image to assets
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(ModernColorScheme.primary, lineWidth: 3)
                                )
                            
                            // Edit Button
                            Button(action: { isEditingProfile = true }) {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(ModernColorScheme.primary)
                                    .background(ModernColorScheme.background)
                                    .clipShape(Circle())
                            }
                            .offset(x: 40, y: 40)
                        }
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : -50)
                        .animation(.easeOut(duration: 0.8), value: isAnimating)
                        
                        // User Info
                        VStack(spacing: 8) {
                            Text(userName)
                                .font(ModernFontScheme.title)
                                .foregroundColor(ModernColorScheme.text)
                            
                            Text(userBio)
                                .font(ModernFontScheme.body)
                                .foregroundColor(ModernColorScheme.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(ModernColorScheme.primary)
                                Text(userLocation)
                                    .font(ModernFontScheme.body)
                                    .foregroundColor(ModernColorScheme.textSecondary)
                            }
                        }
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : -50)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
                    }
                    .padding(.top)
                    
                    // Stats Section
                    HStack(spacing: 20) {
                        StatCard(title: "Rating", value: String(format: "%.1f", userRating), icon: "star.fill")
                        StatCard(title: "Games", value: "\(gamesPlayed)", icon: "basketball.fill")
                        StatCard(title: "Wins", value: "\(gamesWon)", icon: "trophy.fill")
                        StatCard(title: "Win Rate", value: winRate, icon: "chart.line.uptrend.xyaxis")
                    }
                    .padding(.horizontal)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 50)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Recent Activity")
                            .font(ModernFontScheme.heading)
                            .foregroundColor(ModernColorScheme.text)
                            .padding(.horizontal)
                        
                        ForEach(0..<3) { _ in
                            ActivityCard()
                        }
                    }
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 50)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
                }
                .padding(.bottom)
            }
            .background(ModernColorScheme.background.edgesIgnoringSafeArea(.all))
            .navigationBarItems(
                leading: Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(ModernColorScheme.text)
                },
                trailing: Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(ModernColorScheme.text)
                }
            )
            .sheet(isPresented: $isEditingProfile) {
                EditProfileView(
                    userName: $userName,
                    userBio: $userBio,
                    userLocation: $userLocation
                )
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(isAuthenticated: $isAuthenticated)
            }
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Logout")
                        .foregroundColor(ModernColorScheme.text),
                    message: Text("Are you sure you want to logout?")
                        .foregroundColor(ModernColorScheme.textSecondary),
                    primaryButton: .destructive(Text("Logout")) {
                        // Implement logout
                        isAuthenticated = false
                        dismiss()
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(ModernColorScheme.primary)
            
            Text(value)
                .font(ModernFontScheme.heading)
                .foregroundColor(ModernColorScheme.text)
            
            Text(title)
                .font(ModernFontScheme.caption)
                .foregroundColor(ModernColorScheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(ModernColorScheme.surface)
        .cornerRadius(15)
    }
}

struct ActivityCard: View {
    var body: some View {
        HStack(spacing: 15) {
            // Activity Icon
            Image(systemName: "basketball.fill")
                .font(.title2)
                .foregroundColor(ModernColorScheme.primary)
                .frame(width: 40, height: 40)
                .background(ModernColorScheme.surface)
                .cornerRadius(10)
            
            // Activity Info
            VStack(alignment: .leading, spacing: 4) {
                Text("Drop-In Game")
                    .font(ModernFontScheme.body)
                    .foregroundColor(ModernColorScheme.text)
                
                Text("Earl Haig Secondary School")
                    .font(ModernFontScheme.caption)
                    .foregroundColor(ModernColorScheme.textSecondary)
            }
            
            Spacer()
            
            // Time
            Text("2h ago")
                .font(ModernFontScheme.caption)
                .foregroundColor(ModernColorScheme.textSecondary)
        }
        .padding()
        .background(ModernColorScheme.surface)
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var userName: String
    @Binding var userBio: String
    @Binding var userLocation: String
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Information")) {
                    TextField("Name", text: $userName)
                    TextField("Bio", text: $userBio)
                    TextField("Location", text: $userLocation)
                }
                
                Section {
                    Button(action: {
                        // Implement profile picture change
                    }) {
                        HStack {
                            Text("Change Profile Picture")
                            Spacer()
                            Image(systemName: "photo")
                                .foregroundColor(ModernColorScheme.primary)
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    // Implement save changes
                    dismiss()
                }
            )
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = true
    @State private var locationEnabled = true
    @State private var chatNotifications = true
    @State private var gameInvites = true
    @State private var courtUpdates = true
    @State private var searchRadius = 10.0 // km
    @State private var showLogoutAlert = false
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                }
                
                Section(header: Text("Location")) {
                    Toggle("Enable Location Services", isOn: $locationEnabled)
                    
                    if locationEnabled {
                        VStack(alignment: .leading) {
                            Text("Search Radius: \(Int(searchRadius)) km")
                            Slider(value: $searchRadius, in: 1...50, step: 1)
                        }
                    }
                }
                
                Section(header: Text("Notifications")) {
                    Toggle("Enable All Notifications", isOn: $notificationsEnabled)
                    
                    if notificationsEnabled {
                        Toggle("Chat Messages", isOn: $chatNotifications)
                        Toggle("Game Invites", isOn: $gameInvites)
                        Toggle("Court Updates", isOn: $courtUpdates)
                    }
                }
                
                Section(header: Text("Account")) {
                    Button(action: {
                        // Implement change password
                    }) {
                        HStack {
                            Text("Change Password")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(ModernColorScheme.textSecondary)
                        }
                    }
                    
                    Button(action: {
                        // Implement privacy settings
                    }) {
                        HStack {
                            Text("Privacy Settings")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(ModernColorScheme.textSecondary)
                        }
                    }
                }
                
                Section {
                    Button(action: { showLogoutAlert = true }) {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Logout")
                        .foregroundColor(ModernColorScheme.text),
                    message: Text("Are you sure you want to logout?")
                        .foregroundColor(ModernColorScheme.textSecondary),
                    primaryButton: .destructive(Text("Logout")) {
                        isAuthenticated = false
                        dismiss()
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isAuthenticated: .constant(true))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isAuthenticated: .constant(true))
    }
}
