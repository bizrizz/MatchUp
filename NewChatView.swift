import SwiftUI

struct NewChatView: View {
    @Binding var chats: [Chat]
    @Environment(\.presentationMode) var presentationMode
    @State private var chatName = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Chat")) {
                    TextField("Enter name", text: $chatName)
                }
            }
            .navigationBarTitle("New Chat", displayMode: .inline)
            .navigationBarItems(leading:
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }, trailing:
                Button("Create") {
                    createChat()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(chatName.isEmpty)
            )
        }
    }

    func createChat() {
        let newChat = Chat(id: UUID(), name: chatName, lastMessage: "", timestamp: "Now")
        chats.append(newChat)
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView(chats: .constant([]))
    }
}
