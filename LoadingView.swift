import SwiftUI

struct LoadingScreenView: View {
    var body: some View {
        VStack {
            Image("logoimage") // Replace "your_logo" with the name of your logo image asset
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200) // Adjust the size as needed

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2) // Adjust the size of the loading circle
                .padding(.top, 50)
        }
        .padding()
    }
}

struct LoadingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreenView()
    }
}
