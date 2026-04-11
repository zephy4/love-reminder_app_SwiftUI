
import SwiftUI
import UserNotifications

class NotificationManager {

    static let instance = NotificationManager()

    func permissions() {
        let options: UNAuthorizationOptions = [
            .alert, .badge, .sound,
        ]
        UNUserNotificationCenter.current().requestAuthorization(
            options: options
        ) {
            (success, error)
            in
            if let error = error {
                print(
                    "Error Requesting Notifications Permissions: \(error.localizedDescription)"
                )
            } else {
                print("Permissions granted")
            }
        }
    }

    func deliverNotifications(body: String) {

        let content = UNMutableNotificationContent()

        content.title = "Akasha Jabeen reminds you:"
        content.body = body
        content.sound = .default
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 21600,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
