import SwiftUI

struct SecondScreen: View {
    @StateObject private var vm = QuoteViewModel()
    @State private var newQuote: String = ""
    @State private var didSave: Bool = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Add a new quote")
                    .font(.title2)
                    .fontWeight(.semibold)

                TextField(
                    "Type your loving words here…",
                    text: $newQuote,
                    axis: .vertical
                )
                .textFieldStyle(.roundedBorder)
                .lineLimit(3, reservesSpace: true)

                if vm.isUploading {
                    ProgressView("Saving…")
                } else if let error = vm.uploadError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                } else if didSave {
                    Text("Saved to Akasha’s quotes 💖")
                        .foregroundColor(.green)
                        .font(.footnote)
                }
                Button {
                    didSave = false
                    vm.addQuote(text: newQuote) { error in
                        if error == nil {
                            newQuote = ""
                            didSave = true
                        }
                    }
                } label: {
                    Text("Save Quote")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            newQuote.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ).isEmpty ? Color.gray.opacity(0.4) : Color.pink
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(
                    newQuote.trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty || vm.isUploading
                )

                Spacer()
            }
            .padding()
            .navigationTitle("New Quote")
        }
    }
}

#Preview {
    SecondScreen()
}
