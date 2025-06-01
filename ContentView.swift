import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        NavigationView {
            // Skip the loading screen and go directly to the app
            // The user will start with the DropInView as configured in AppDelegate.swift
            MainTabView(isAuthenticated: $isAuthenticated)
                .navigationBarHidden(true)
        }
    }
}

// NextView is already defined in LoadingView.swift, so we don't need to redefine it here

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
