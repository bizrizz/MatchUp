import SwiftUI
import UIKit

// Define a modern color scheme
struct ModernColorScheme {
    static let primary = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let secondary = Color(red: 0.3, green: 0.8, blue: 0.6)
    static let background = Color(red: 0.1, green: 0.1, blue: 0.15)
    static let surface = Color(red: 0.15, green: 0.15, blue: 0.2)
    static let text = Color.white
    static let textSecondary = Color.gray
}

// Define a modern font scheme
struct ModernFontScheme {
    static let title = Font.custom("Inter", size: 32).weight(.bold)
    static let heading = Font.custom("Inter", size: 24).weight(.semibold)
    static let body = Font.custom("Inter", size: 16)
    static let caption = Font.custom("Inter", size: 14)
}

// Define the AppDelegatex  
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Perform any final initialization of your application.
        return true
    }
}

// Define the SwiftUI App
@main
struct matchUp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var showLoadingScreen = false  // Loading screen disabled
    @State private var isAuthenticated = false
    @State private var showDropInView = true  // Show DropInView first
    @State private var showLogin = false      // Initially hide LoginView
    @State private var showCreateAccount = false  // New state for handling create account view

    var body: some Scene {
        WindowGroup {
            Group {
                // Loading screen completely removed - go directly to authentication flow
                if false {
                    // This condition will never be true, effectively removing the loading screen
                    EmptyView()
                } else if !isAuthenticated && showLogin {
                    // Show the LoginView when `showLogin` is true and the user is not authenticated
                    LoginView(isAuthenticated: $isAuthenticated,
                              showDropInView: $showDropInView,
                              showLogin: $showLogin,
                              showCreateAccount: $showCreateAccount)  // Pass showCreateAccount binding
                } else if showDropInView {
                    // Show DropInView when the flag is set to true
                    DropInView(
                               showDropInView: $showDropInView,
                               showLogin: $showLogin,
                               showCreateAccount: $showCreateAccount)  // Pass showCreateAccount if needed
                } else {
                    CustomTabView(isAuthenticated: $isAuthenticated)
                    MainTabView(isAuthenticated: $isAuthenticated)
                }
            }
            .preferredColorScheme(.dark)
            .accentColor(ModernColorScheme.primary)
        }
    }
}
