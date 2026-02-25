import SwiftUI
import MapKit
import DesignSystem
import SharedModels
import Networking

/// Map-based view showing task locations with compensation annotations.
struct TaskMapView: View {

    // MARK: - Properties

    let tasks: [AgentTask]
    let taskService: TaskServiceProtocol
    let currentUser: User

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431),
            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        )
    )
    @State private var selectedTask: AgentTask?

    // MARK: - Body

    var body: some View {
        Map(position: $cameraPosition, selection: $selectedTask) {
            ForEach(tasks) { task in
                Annotation(
                    task.formattedCompensation,
                    coordinate: CLLocationCoordinate2D(
                        latitude: task.latitude,
                        longitude: task.longitude
                    ),
                    anchor: .bottom
                ) {
                    annotationView(for: task)
                }
                .tag(task)
            }
        }
        .mapStyle(.standard(elevation: .flat))
        .sheet(item: $selectedTask) { task in
            NavigationStack {
                TaskDetailView(
                    taskId: task.id,
                    taskService: taskService,
                    currentUser: currentUser,
                    preloadedTask: task
                )
            }
            .presentationDetents([.medium, .large])
        }
    }

    // MARK: - Annotation View

    private func annotationView(for task: AgentTask) -> some View {
        VStack(spacing: 0) {
            Text(task.formattedCompensation)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, AppSpacing.xs)
                .padding(.vertical, AppSpacing.xxs)
                .background(AppColors.warmCoral)
                .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))

            // Arrow
            Triangle()
                .fill(AppColors.warmCoral)
                .frame(width: 12, height: 6)
        }
        .onTapGesture {
            selectedTask = task
        }
    }
}

// MARK: - Triangle Shape

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview

#Preview {
    TaskMapView(
        tasks: MockTaskService.sampleTasks,
        taskService: MockTaskService(),
        currentUser: MockUsers.currentUser
    )
}
