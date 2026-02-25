import SwiftUI
import SharedModels
import Authentication

struct AppCoordinator: View {
    let dependencies: AppDependencies
    @State private var currentUser: User?
    @State private var isAuthenticated = false

    var body: some View {
        Group {
            if isAuthenticated, let user = currentUser {
                ContentView(
                    dependencies: dependencies,
                    currentUser: user,
                    onSignOut: {
                        withAnimation {
                            isAuthenticated = false
                            currentUser = nil
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            } else {
                AuthenticationModule(
                    authService: dependencies.authService,
                    onAuthenticated: { user in
                        withAnimation {
                            currentUser = user
                            isAuthenticated = true
                        }
                    }
                )
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: isAuthenticated)
    }
}
