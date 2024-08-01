import SwiftUI

struct CustomAvatarView: View {
    var body: some View {
        VStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .overlay(
                    Text("😀")
                        .font(.largeTitle)
                )
            
            // Add customization options below
            HStack {
                Button("Hair") {
                    // Toggle or modify hair style
                }
                Button("Eyes") {
                    // Toggle or modify eye style
                }
            }
        }
    }
}

struct MemojiCustomizationView: View {
    var body: some View {
        VStack {
            Text("Customize Your Avatar")
                .font(.largeTitle).bold()
                .padding()
            
            CustomAvatarView()
                .padding()
            
            Button(action: {
                // Save avatar customizations
            }) {
                Text("Save Avatar")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .font(.headline)
            }
        }
        .padding()
    }
}

struct MemojiCustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        MemojiCustomizationView()
    }
}
