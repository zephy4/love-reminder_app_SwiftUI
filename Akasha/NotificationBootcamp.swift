import SwiftUI
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {

    static let instance = NotificationManager()

    /// One stable id so we replace/keep a single reminder instead of stacking.
    private let quoteNotificationId = "akasha.sixHourQuote"
    private let sixHours: TimeInterval = 6 * 60 * 60

    private override init() {
        super.init()
    }

    func configure() {
        UNUserNotificationCenter.current().delegate = self
    }

    func permissions() {
        let options: UNAuthorizationOptions = [
            .alert, .badge, .sound,
        ]
        UNUserNotificationCenter.current().requestAuthorization(
            options: options
        ) { success, error in
            if let error = error {
                print(
                    "Error Requesting Notifications Permissions: \(error.localizedDescription)"
                )
            } else {
                print("Permissions granted")
            }
        }
    }

    /// Schedules at most one 6-hour repeating quote notification.
    /// Safe to call after every Firebase fetch — it will not stack or reset the timer.
    func ensureSixHourQuoteNotification(body: String) {
        let center = UNUserNotificationCenter.current()

        center.getPendingNotificationRequests { [weak self] requests in
            guard let self else { return }

            let leftoverIds = requests
                .map(\.identifier)
                .filter { $0 != self.quoteNotificationId }

            if !leftoverIds.isEmpty {
                center.removePendingNotificationRequests(
                    withIdentifiers: leftoverIds
                )
            }

            if requests.contains(where: { $0.identifier == self.quoteNotificationId }) {
                return
            }

            self.addSixHourNotification(body: body)
        }
    }

    private func addSixHourNotification(body: String) {
        let content = UNMutableNotificationContent()
        content.title = "Akasha Jabeen reminds you:"
        content.body = body
        content.sound = .default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: sixHours,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: quoteNotificationId,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print(
                    "Error scheduling quote notification: \(error.localizedDescription)"
                )
            }
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
