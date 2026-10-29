import SwiftUI

@main
public struct TelegramDriveApp: App {
    @StateObject private var appState = AppState()

    public init() {}

    public var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appState)
                .preferredColorScheme(appState.currentTheme == .light ? .light : .dark)
        }
    }
}
