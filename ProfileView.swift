import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "🧑‍🦱") // Replace with actual user Memoji image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    Text("Adam Bizios")
                        .font(.headline)
                }
                Spacer()
            }
            .padding()

            Form {
                Section(header: Text("Account")) {
                    Text("Username: adam.bizios@example.com") // Replace with actual username
                    Text("Password: ••••••••")
                }
            }
        }
        .navigationTitle("Profile")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
