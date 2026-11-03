import FirebaseFirestore

class QuoteViewModel: ObservableObject {

    @Published var quote: String = "Loading..."
    @Published var uploadError: String?
    @Published var isUploading: Bool = false

    private var db = Firestore.firestore()

    func fetchQuote() {

        db.collection("quotes").getDocuments { [weak self] snapshot, error in

            guard let self = self else { return }

            if let error = error {
                print("Error fetching: \(error)")
                return
            }

            guard
                let documents = snapshot?.documents,
                !documents.isEmpty
            else {
                DispatchQueue.main.async {
                    self.quote = "No quotes yet. Add one! 💕"
                }
                return
            }

            if let randomDoc = documents.randomElement() {

                let text = randomDoc.data()["text"] as? String ?? ""

                DispatchQueue.main.async {
                    self.quote = text
                }
                NotificationManager.instance.ensureSixHourQuoteNotification(
                    body: text
                )
            }
        }
    }

    func addQuote(text: String, completion: ((Error?) -> Void)? = nil) {

        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            completion?(nil)
            return
        }

        isUploading = true
        uploadError = nil

        let data: [String: Any] = ["text": trimmed]

        db.collection("quotes").addDocument(data: data) { [weak self] error in
            DispatchQueue.main.async {
                self?.isUploading = false
                if let error = error {
                    self?.uploadError = error.localizedDescription
                    print("Error adding quote: \(error)")
                    completion?(error)
                } else {
                    completion?(nil)
                }
            }
        }
    }
}
