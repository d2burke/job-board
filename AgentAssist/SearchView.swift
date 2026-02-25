import SwiftUI
import SharedModels
import DesignSystem
import Networking

struct SearchView: View {
    let taskService: any TaskServiceProtocol
    @State private var searchText = ""
    @State private var allTasks: [AgentTask] = []
    @State private var isLoading = false

    private var filteredTasks: [AgentTask] {
        guard !searchText.isEmpty else { return [] }
        let query = searchText.lowercased()
        return allTasks.filter {
            $0.title.lowercased().contains(query) ||
            $0.description.lowercased().contains(query) ||
            $0.address.lowercased().contains(query) ||
            $0.city.lowercased().contains(query) ||
            $0.category.rawValue.lowercased().contains(query)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if searchText.isEmpty {
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "Search Tasks",
                        message: "Search by title, location, or category"
                    )
                } else if filteredTasks.isEmpty {
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "No Results",
                        message: "No tasks match \"\(searchText)\""
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppSpacing.sm) {
                            ForEach(filteredTasks) { task in
                                TaskCard(
                                    title: task.title,
                                    category: task.category.rawValue,
                                    categoryColor: categoryColor(for: task.category),
                                    compensation: task.formattedCompensation,
                                    location: "\(task.city), \(task.state)",
                                    timeAgo: timeAgo(from: task.createdAt),
                                    scheduledDate: nil,
                                    avatarURL: task.postedBy.avatarURL
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.top, AppSpacing.sm)
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Tasks, locations, categories...")
            .task {
                await loadTasks()
            }
        }
    }

    private func loadTasks() async {
        isLoading = true
        do {
            allTasks = try await taskService.fetchNearbyTasks(latitude: 0, longitude: 0, radiusMiles: 50)
        } catch {
            allTasks = []
        }
        isLoading = false
    }

    private func categoryColor(for category: TaskCategory) -> Color {
        switch category {
        case .openHouse: return AppColors.warmCoral
        case .photography: return Color.blue
        case .showing: return AppColors.successGreen
        case .signInstall: return Color.orange
        case .staging: return Color.purple
        case .lockbox: return Color.teal
        case .inspection: return AppColors.warningAmber
        case .flyerDelivery: return Color.indigo
        case .research: return Color.cyan
        case .other: return AppColors.softGray
        }
    }

    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
