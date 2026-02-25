import SwiftUI

@main
struct AgentAssistApp: App {
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            AppCoordinator(dependencies: dependencies)
        }
    }
}
