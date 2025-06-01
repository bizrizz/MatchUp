import SwiftUI
import Combine
import CoreLocation

struct ChatView: View {
    @State private var searchText = ""
    @State private var chats: [Chat] = []  // Chats will be fetched based on the user's joined locations
    @State private var showingNewChatView = false
    @State private var joinedLocations: [Int] = []  // Store location IDs as integers

    var body: some View {
        NavigationStack {
            VStack {
                // Right-aligned New Chat Button
                Button(action: {
                    showingNewChatView = true
                }) {
                    HStack {
                        Spacer()  // Push content to the right
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
//                        Text("Join Group Chat")
//                            .font(.headline)
//                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    .padding(.top, 0.5) // Adjust to your preferred spacing

                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .sheet(isPresented: $showingNewChatView) {
                    NewChatView(chats: $chats)
                }

                // Search bar below the New Chat button
                SearchBar(text: $searchText)
                    .padding(.top, 0.5) // Adjust to your preferred spacing


                // List of court chats
                if chats.isEmpty {
                    // Display court chats directly instead of loading message
                    List {
                        ForEach(getBasketballCourtChats()) { chat in
                            NavigationLink(destination: CourtChatView(courtName: chat.name)) {
                                ChatRow(chat: chat)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    // Show existing chats if any
                    List {
                        ForEach(chats.filter { searchText.isEmpty ? true : $0.name.contains(searchText) }) { chat in
                            NavigationLink(destination: ChatDetailedView(chat: chat)) {
                                ChatRow(chat: chat)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .onAppear {
                // Load both joined chats and basketball court chats
                loadJoinedChats { success, error in
                    if let error = error {
                        print("Failed to load chats: \(error.localizedDescription)")
                    }
                }
                
                // If no chats are loaded, populate with court chats
                if chats.isEmpty {
                    chats = getBasketballCourtChats()
                }
            }
        }
    }

    // Get basketball court chats
    func getBasketballCourtChats() -> [Chat] {
        // Access the schools array directly without creating a HomeView instance
        // This avoids the binding issues with HomeView initialization
        // Using the exact same schools as in HomeView
        let schools = [
            BasketballSchool(
                name: "Dr Norman Bethune Collegiate Institute", 
                coordinate: CLLocationCoordinate2D(latitude: 43.8016, longitude: -79.3181), 
                activePlayers: 5, 
                usernames: ["player1", "player2", "player3"],
                description: "Outdoor court with 2 hoops, freshly painted lines, and good lighting for evening games.",
                rating: 4.7,
                openHours: "6:00 AM - 10:00 PM",
                courtType: "Full court with bleachers"
            ),
            BasketballSchool(
                name: "Lester B. Pearson Collegiate Institute", 
                coordinate: CLLocationCoordinate2D(latitude: 43.8035, longitude: -79.2256), 
                activePlayers: 3, 
                usernames: ["playerA", "playerB"],
                description: "Indoor gymnasium with 6 hoops, perfect for rainy days and competitive games.",
                rating: 4.5,
                openHours: "7:00 AM - 9:00 PM",
                courtType: "Indoor full court"
            ),
            BasketballSchool(
                name: "Maplewood High School", 
                coordinate: CLLocationCoordinate2D(latitude: 43.7694, longitude: -79.1927), 
                activePlayers: 2, 
                usernames: ["playerX", "playerY"],
                description: "Outdoor court with 4 hoops, popular spot for weekend pickup games and tournaments.",
                rating: 4.2,
                openHours: "8:00 AM - 8:00 PM",
                courtType: "Two half courts"
            ),
            BasketballSchool(
                name: "George B Little Public School", 
                coordinate: CLLocationCoordinate2D(latitude: 43.7654, longitude: -79.2154), 
                activePlayers: 4, 
                usernames: ["playerC", "playerD"],
                description: "Small but well-maintained court, great for beginners and casual players.",
                rating: 4.0,
                openHours: "7:00 AM - 7:00 PM",
                courtType: "Half court"
            ),
            BasketballSchool(
                name: "David and Mary Thomson Collegiate Institute", 
                coordinate: CLLocationCoordinate2D(latitude: 43.7506, longitude: -79.2707), 
                activePlayers: 1, 
                usernames: ["playerE"],
                description: "Recently renovated court with new backboards and nets, excellent playing surface.",
                rating: 4.8,
                openHours: "6:00 AM - 9:00 PM",
                courtType: "Full court with lights"
            ),
            BasketballSchool(
                name: "Newtonbrook Secondary School", 
                coordinate: CLLocationCoordinate2D(latitude: 43.7981, longitude: -79.4198), 
                activePlayers: 6, 
                usernames: ["playerF", "playerG"],
                description: "Large outdoor court that hosts local tournaments, with water fountains nearby.",
                rating: 4.6,
                openHours: "7:00 AM - 10:00 PM",
                courtType: "Full court with spectator area"
            ),
            BasketballSchool(
                name: "Georges Vanier Secondary School", 
                coordinate: CLLocationCoordinate2D(latitude: 43.7772, longitude: -79.3464), 
                activePlayers: 3, 
                usernames: ["playerH", "playerI"],
                description: "Covered outdoor court, perfect for playing in light rain or hot sunny days.",
                rating: 4.4,
                openHours: "8:00 AM - 8:00 PM",
                courtType: "Covered full court"
            ),
            BasketballSchool(
                name: "Northview Heights Secondary School", 
                coordinate: CLLocationCoordinate2D(latitude: 43.7808, longitude: -79.4391), 
                activePlayers: 2, 
                usernames: ["playerJ", "playerK"],
                description: "Multiple courts with varying skill levels, from beginner to advanced players.",
                rating: 4.3,
                openHours: "6:30 AM - 9:30 PM",
                courtType: "Multiple courts (3)"
            ),
            BasketballSchool(
                name: "Earl Haig Secondary School", 
                coordinate: CLLocationCoordinate2D(latitude: 43.7663, longitude: -79.4018), 
                activePlayers: 7, 
                usernames: ["playerL", "playerM"],
                description: "Popular spot for competitive players, with regular weekend tournaments.",
                rating: 4.9,
                openHours: "7:00 AM - 11:00 PM",
                courtType: "Professional full court"
            ),
            BasketballSchool(
                name: "Don Mills Collegiate Institute", 
                coordinate: CLLocationCoordinate2D(latitude: 43.7380, longitude: -79.3343), 
                activePlayers: 5, 
                usernames: ["playerN", "playerO"],
                description: "Well-lit court with nearby parking, good for evening games after work.",
                rating: 4.5,
                openHours: "6:00 AM - 10:00 PM",
                courtType: "Full court with night lighting"
            )
        ]
        
        // Create a chat for each basketball court
        return schools.map { school in
            Chat(
                id: Int.random(in: 1000...9999), // Generate a random ID for the chat
                name: school.name,
                lastMessage: "\(school.activePlayers) active players",
                timestamp: Date(),
                unreadCount: school.activePlayers > 0 ? Int.random(in: 0...school.activePlayers) : 0,
                isActive: school.activePlayers > 0
            )
        }
    }
    
    // Load joined chats based on location IDs stored in UserDefaults
    func loadJoinedChats(completion: @escaping (Bool, Error?) -> Void) {
        let networkManager = NetworkManager()

        guard let userId = UserDefaults.standard.value(forKey: "loggedInUserId") as? Int else {
//            print(UserDefaults.standard.value(forKey: "loggedInUserId"))
            print("User ID not found")
            return
        }
        networkManager.fetchUserLocations(userId: userId) { success, error in
            DispatchQueue.main.async {
                if success {
                    // Retrieve the location IDs from UserDefaults
                    self.joinedLocations = UserDefaults.standard.array(forKey: "joinedLocations") as? [Int] ?? []
                } else {
                    print("Error fetching joined locations: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
        guard let url = URL(string: "https://matchup-api.xyz/api/v1/locations") else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            guard let data = data else {
                print("Error: No data received")
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from the server."]))
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Server second Response: \(jsonString)")
            }
            
            
            do {
                // Define the structure of the response based on the API's JSON
                struct Location: Codable {
                    var locationId: Int
                    var locationName: String
                    var locationAddress: String
                    var locationZipCode: String
                    var locationActivePlayers: Int
                    var locationReviews: String
                }

                
                // Decode the array of Location objects

                let locations: [Location] = try JSONDecoder().decode([Location].self, from: data)
                
                // Load the joined location IDs from UserDefaults
                if let savedLocations = UserDefaults.standard.array(forKey: "joinedLocations") as? [Int] {
                    joinedLocations = savedLocations
                }
                
                // Filter locations based on the user's joined locations
                print(joinedLocations)
                let joinedChats = locations.filter { location in
                    joinedLocations.contains(location.locationId)
                }
                
                // Create Chat objects for each joined location
                chats = joinedChats.map { location in
                    Chat(id: location.locationId, name: location.locationName)
                }
                
                DispatchQueue.main.async {
                    completion(true, nil)  // Success
                }
                
            } catch {
                print("Error decoding chats: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, error)  // Failure
                }
            }
        }.resume()
    }
}

//        if let savedLocations = UserDefaults.standard.array(forKey: "joinedLocations") as? [UUID] {
//            joinedLocations = savedLocations

            // Fetch chats corresponding to the joined location IDs
//            let allChats: [Chat] = [
//                Chat(id: UUID(), name: "Slone School chat", lastMessage: "Welcome to location A!", timestamp: "10:45 AM"),
//                Chat(id: UUID(), name: "Hoop Dome chat", lastMessage: "Hey, let's play!", timestamp: "Yesterday"),
//                Chat(id: UUID(), name: "Don Valley chat", lastMessage: "Great game!", timestamp: "Monday")
//            ]
//        chats = allChats
//            chats = allChats.filter { joinedLocations.contains($0.id) }
//        }
//    }


struct Chat: Identifiable, Decodable {
    var id: Int
    var name: String
    var lastMessage: String = ""
    var timestamp: Date = Date()
    var unreadCount: Int = 0
    var isActive: Bool = false
    
    init(id: Int, name: String, lastMessage: String = "", timestamp: Date = Date(), unreadCount: Int = 0, isActive: Bool = false) {
        self.id = id
        self.name = name
        self.lastMessage = lastMessage
        self.timestamp = timestamp
        self.unreadCount = unreadCount
        self.isActive = isActive
    }
    
    // For Decodable support with minimal fields
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}




struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
        }
        .padding(.top)
    }
}

struct ChatRow: View {
    var chat: Chat

    var body: some View {
        HStack {
            // Court icon with active indicator
            ZStack {
                Circle()
                    .fill(chat.isActive ? Color.green : Color.blue)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "basketball.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    )
                
                // Unread count badge
                if chat.unreadCount > 0 {
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 22, height: 22)
                        
                        Text("\(chat.unreadCount)")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .offset(x: 18, y: -18)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(chat.name)
                    .font(.headline)
                    .lineLimit(1)
                
                if !chat.lastMessage.isEmpty {
                    Text(chat.lastMessage)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }

            Spacer()
            
            // Timestamp
            if chat.timestamp > Date(timeIntervalSince1970: 0) {
                Text(formatTimestamp(chat.timestamp))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
    
    // Format timestamp to show time or date depending on how recent
    private func formatTimestamp(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            return formatter.string(from: date)
        }
    }
}



