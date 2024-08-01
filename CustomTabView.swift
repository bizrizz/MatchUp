import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }

                ContentView() // Your map view
                    .tag(1)
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("Map")
                    }

                ChatView()
                    .tag(2)
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("Messages")
                    }

                ProfileView()
                    .tag(3)
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .background(Color.white.opacity(0.0)) // Makes the background transparent
            .accentColor(.blue) // Change this to customize the accent color of the tab items

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        selectedTab = 0
                    }) {
                        Image(systemName: "house.fill")
                            .foregroundColor(selectedTab == 0 ? .blue : .gray)
                            .padding()
                    }
                    Spacer()
                    Button(action: {
                        selectedTab = 1
                    }) {
                        Image(systemName: "map.fill")
                            .foregroundColor(selectedTab == 1 ? .blue : .gray)
                            .padding()
                    }
                    Spacer()
                    Button(action: {
                        selectedTab = 2
                    }) {
                        Image(systemName: "message.fill")
                            .foregroundColor(selectedTab == 2 ? .blue : .gray)
                            .padding()
                    }
                    Spacer()
                    Button(action: {
                        selectedTab = 3
                    }) {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(selectedTab == 3 ? .blue : .gray)
                            .padding()
                    }
                    Spacer()
                }
                .background(Color.white.opacity(0.7)) // Semi-transparent background
                .clipShape(Capsule())
                .padding()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToChat)) { _ in
            selectedTab = 2
        }
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
