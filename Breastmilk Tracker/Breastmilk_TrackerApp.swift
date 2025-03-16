import SwiftUI

@main
struct BreastmilkTrackerApp: App {
    // Override the interface style to light mode on app launch
    init() {
        // Ensure the app starts in light mode
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
