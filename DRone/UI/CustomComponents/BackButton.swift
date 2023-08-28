import SwiftUI

struct BackButton<TrailingItems: View>: View {
    @Environment(\.dismiss) private var dismiss
    let text: String
    @ViewBuilder var trailingItems: () -> TrailingItems
    var action: (() -> Void)?
    
    var body: some View {
        HStack {
            Button(action: {
                if let action = action {
                    action()
                } else {
                    dismiss()
                }
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 14, height: 18)
                        .foregroundColor(.white)
                    
                    Text(text)
                        .font(.custom("Arial", size: 17)) // Use your custom font here
                        .foregroundColor(.white)
                }
            }
            
            Spacer()

            trailingItems()
        }
        .padding(.leading, 10)
        .padding(.vertical, 10)
    }
    
    init(text: String, @ViewBuilder trailingItems: @escaping () -> TrailingItems = {EmptyView()}, action: (() -> Void)? = nil) {
        self.text = text
        self.action = action
        self.trailingItems = trailingItems
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(text: "Back") {
            Text("Trailing Content")
        }
    }
}
