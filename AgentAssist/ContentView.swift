import SwiftUI
import SharedModels
import DesignSystem
import TaskMarketplace
import PostTask
import Messaging
import Profile
import Notifications

struct ContentView: View {
    let dependencies: AppDependencies
    let currentUser: User
    let onSignOut: () -> Void
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TaskMarketplaceModule(
                taskService: dependencies.taskService,
                currentUser: currentUser
            )
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)

            SearchView(taskService: dependencies.taskService)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)

            PostTaskModule(
                taskService: dependencies.taskService,
                currentUser: currentUser
            )
            .tabItem {
                Label("Post", systemImage: "plus.circle.fill")
            }
            .tag(2)

            MessagingModule(
                messageService: dependencies.messageService,
                currentUser: currentUser
            )
            .tabItem {
                Label("Messages", systemImage: "message.fill")
            }
            .tag(3)

            ProfileModule(
                profileService: dependencies.profileService,
                paymentService: dependencies.paymentService,
                user: currentUser,
                onSignOut: onSignOut
            )
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .tag(4)
        }
        .tint(AppColors.warmCoral)
    }
}
