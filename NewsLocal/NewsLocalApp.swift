import SwiftUI

/// Main app entry point
@main
struct NewsLocalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light) // Can be changed to .dark or nil for system preference
        }
    }
}
