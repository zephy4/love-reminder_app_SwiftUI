

import WidgetKit
import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), quote: "Loading quote...")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        fetchQuote { quote in
            let entry = SimpleEntry(date: Date(), quote: quote)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        fetchQuote { quote in
            let currentDate = Date()
            let entry = SimpleEntry(date: currentDate, quote: quote)

            // Ask WidgetKit to refresh the widget after 6 hours.
            let refreshDate = Calendar.current.date(byAdding: .hour, value: 6, to: currentDate) ?? currentDate.addingTimeInterval(6 * 60 * 60)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }

    private func configureFirebaseIfNeeded() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    private func fetchQuote(completion: @escaping (String) -> Void) {
        configureFirebaseIfNeeded()

        let db = Firestore.firestore()
        db.collection("quotes").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching quote for widget: \(error)")
                completion("Stay inspired.")
                return
            }

            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion("No quotes available.")
                return
            }

            if let randomDoc = documents.randomElement() {
                let text = randomDoc.data()["text"] as? String ?? "Stay inspired."
                completion(text)
            } else {
                completion("Stay inspired.")
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
}

struct QuoteWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text("Akasha Jabeen 💕")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            Text("says:")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.9))

            Text("“\(entry.quote)”")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineLimit(4)
                .minimumScaleFactor(0.7)
        }
        .padding(12)
    }
}


struct QuoteWidget: Widget {
    let kind: String = "QuoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                QuoteWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        LinearGradient(
                            colors: [
                                Color.pink.opacity(0.45),
                                Color.purple.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                   
            } else {
                QuoteWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Akasha Love Notes")
        .description("A loving quote from Akasha, refreshed through the day.")
    }
}

// MARK: - Widget Previews (for Xcode canvas)

@available(iOSApplicationExtension 17.0, *)
#Preview(as: .systemSmall) {
    QuoteWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        quote: "You are my favorite notification of the day. 💖"
    )
}

@available(iOSApplicationExtension 17.0, *)
#Preview(as: .systemMedium) {
    QuoteWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        quote: "I prayed for you long before I met you, and every day with you is an answered dua. 🌙"
    )
}
