import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {

        WindowGroup {
            NavigationView {
                SplashView()
                    .onAppear {
                        NotificationManager.instance.permissions()
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
            }
        }
    }
}
