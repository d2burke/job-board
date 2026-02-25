# AgentAssist — Build Plan

## Architecture: Modular SPM Packages for Agentic Engineering

Every feature is an independent Swift Package with its own `Package.swift`, source files, tests, and mock data. Modules communicate through **protocol-based interfaces** defined in the `Networking` package. No feature module depends on another feature module — they only depend on shared foundations.

This means:
- **Separation**: Clear boundaries, no circular dependencies
- **Sandboxing**: Each module builds and tests in isolation (`swift build && swift test` per package)
- **Parallelization**: Multiple agents (or developers) can work on different modules simultaneously with zero merge conflicts

---

## Dependency Graph

```
                    ┌─────────────┐
                    │  App Shell  │  (thin — composes modules)
                    └──────┬──────┘
                           │ depends on all feature modules
          ┌────────────────┼────────────────┐
          │                │                │
   ┌──────┴──────┐  ┌─────┴──────┐  ┌──────┴──────┐
   │    Auth     │  │  Task      │  │  PostTask   │
   │             │  │  Market    │  │             │
   └──────┬──────┘  └─────┬──────┘  └──────┬──────┘
          │                │                │
   ┌──────┴──────┐  ┌─────┴──────┐  ┌──────┴──────┐
   │  Messaging  │  │  Profile   │  │ Notifications│
   └──────┬──────┘  └─────┬──────┘  └──────┬──────┘
          │                │                │
          └────────────────┼────────────────┘
                           │ all features depend on ▼
                  ┌────────┴─────────┐
                  │    Networking    │  (protocols + mocks)
                  └────────┬─────────┘
                           │
              ┌────────────┼────────────┐
              │                         │
     ┌────────┴────────┐    ┌──────────┴──────────┐
     │  SharedModels   │    │    DesignSystem      │
     │  (zero deps)    │    │    (zero deps)       │
     └─────────────────┘    └─────────────────────┘
```

**Rule**: Feature modules NEVER depend on each other. Cross-feature communication happens through the App Shell's coordinator layer.

---

## Package Manifest

### Directory Structure

```
job-board/
├── PRODUCT_SPEC.md
├── MARKET_RESEARCH.md
├── PLAN.md
├── AgentAssist/                          # Main app target (thin shell)
│   ├── AgentAssistApp.swift              # @main entry point
│   ├── AppCoordinator.swift              # Tab routing + deep links
│   ├── AppDependencies.swift             # DI container wiring mocks/real services
│   └── ContentView.swift                 # Root TabView
│
└── Packages/
    ├── DesignSystem/                     # 🎨 Zero dependencies
    │   ├── Package.swift
    │   ├── Sources/DesignSystem/
    │   │   ├── Theme/
    │   │   │   ├── AppColors.swift       # Color tokens (light + dark)
    │   │   │   ├── AppTypography.swift   # Type scale + text styles
    │   │   │   └── AppSpacing.swift      # Spacing scale (4pt grid)
    │   │   └── Components/
    │   │       ├── PillButton.swift       # Full-width primary CTA
    │   │       ├── AATextField.swift      # Styled input field
    │   │       ├── AvatarView.swift       # Circular image + badge
    │   │       ├── RatingView.swift       # Star ratings (display + input)
    │   │       ├── CategoryChip.swift     # Pill badge for task types
    │   │       ├── TaskCard.swift         # Task preview card
    │   │       ├── EmptyStateView.swift   # Illustration + CTA
    │   │       ├── LoadingView.swift      # Skeleton shimmer
    │   │       └── StatusBadge.swift      # Task status indicator
    │   └── Tests/DesignSystemTests/
    │       └── ComponentSnapshotTests.swift
    │
    ├── SharedModels/                     # 📦 Zero dependencies
    │   ├── Package.swift
    │   ├── Sources/SharedModels/
    │   │   ├── User.swift                # Agent profile model
    │   │   ├── AgentTask.swift           # Task model
    │   │   ├── TaskCategory.swift        # Enum of task types
    │   │   ├── TaskStatus.swift          # Task lifecycle states
    │   │   ├── Message.swift             # Chat message
    │   │   ├── Conversation.swift        # Chat thread
    │   │   ├── Review.swift              # Rating + review
    │   │   ├── Payment.swift             # Transaction record
    │   │   ├── Badge.swift               # Achievement/verification
    │   │   ├── Notification.swift        # In-app notification
    │   │   └── MockData/
    │   │       ├── MockUsers.swift       # 20+ sample agents
    │   │       ├── MockTasks.swift       # 50+ sample tasks
    │   │       ├── MockMessages.swift    # Sample conversations
    │   │       └── MockReviews.swift     # Sample reviews
    │   └── Tests/SharedModelsTests/
    │       ├── UserTests.swift
    │       ├── AgentTaskTests.swift
    │       └── CodableTests.swift
    │
    ├── Networking/                        # 🔌 Depends on: SharedModels
    │   ├── Package.swift
    │   ├── Sources/Networking/
    │   │   ├── Protocols/
    │   │   │   ├── AuthServiceProtocol.swift
    │   │   │   ├── TaskServiceProtocol.swift
    │   │   │   ├── MessageServiceProtocol.swift
    │   │   │   ├── PaymentServiceProtocol.swift
    │   │   │   ├── ProfileServiceProtocol.swift
    │   │   │   └── NotificationServiceProtocol.swift
    │   │   ├── Mock/
    │   │   │   ├── MockAuthService.swift
    │   │   │   ├── MockTaskService.swift
    │   │   │   ├── MockMessageService.swift
    │   │   │   ├── MockPaymentService.swift
    │   │   │   ├── MockProfileService.swift
    │   │   │   └── MockNotificationService.swift
    │   │   └── Live/
    │   │       └── README.md             # Placeholder for Firebase impl
    │   └── Tests/NetworkingTests/
    │       └── MockServiceTests.swift
    │
    ├── Authentication/                    # 🔐 Depends on: DesignSystem, SharedModels, Networking
    │   ├── Package.swift
    │   ├── Sources/Authentication/
    │   │   ├── AuthViewModel.swift
    │   │   ├── AuthCoordinator.swift      # Manages auth flow navigation
    │   │   └── Views/
    │   │       ├── WelcomeView.swift       # Splash + social auth buttons
    │   │       ├── OnboardingCarousel.swift # 3-screen walkthrough
    │   │       ├── SignInView.swift         # Email + password
    │   │       ├── SignUpView.swift         # Registration form
    │   │       ├── OTPVerificationView.swift
    │   │       └── ProfileSetupView.swift   # License, brokerage, skills
    │   └── Tests/AuthenticationTests/
    │       └── AuthViewModelTests.swift
    │
    ├── TaskMarketplace/                   # 🏠 Depends on: DesignSystem, SharedModels, Networking
    │   ├── Package.swift
    │   ├── Sources/TaskMarketplace/
    │   │   ├── TaskListViewModel.swift
    │   │   ├── TaskDetailViewModel.swift
    │   │   └── Views/
    │   │       ├── TaskFeedView.swift       # Main feed with list/map toggle
    │   │       ├── TaskDetailView.swift     # Full task info + apply
    │   │       ├── TaskMapView.swift        # MapKit view of nearby tasks
    │   │       └── TaskFilterSheet.swift    # Category, distance, price filters
    │   └── Tests/TaskMarketplaceTests/
    │       ├── TaskListViewModelTests.swift
    │       └── TaskDetailViewModelTests.swift
    │
    ├── PostTask/                           # ➕ Depends on: DesignSystem, SharedModels, Networking
    │   ├── Package.swift
    │   ├── Sources/PostTask/
    │   │   ├── PostTaskViewModel.swift
    │   │   └── Views/
    │   │       ├── PostTaskFlow.swift        # Multi-step coordinator
    │   │       ├── CategorySelectView.swift  # Pick task type
    │   │       ├── TaskDetailsForm.swift     # Address, datetime, notes
    │   │       └── TaskPricingView.swift     # Set compensation
    │   └── Tests/PostTaskTests/
    │       └── PostTaskViewModelTests.swift
    │
    ├── Messaging/                          # 💬 Depends on: DesignSystem, SharedModels, Networking
    │   ├── Package.swift
    │   ├── Sources/Messaging/
    │   │   ├── ChatViewModel.swift
    │   │   ├── ConversationListViewModel.swift
    │   │   └── Views/
    │   │       ├── ConversationListView.swift  # Chat inbox
    │   │       └── ChatView.swift              # Message thread
    │   └── Tests/MessagingTests/
    │       └── ChatViewModelTests.swift
    │
    ├── Profile/                            # 👤 Depends on: DesignSystem, SharedModels, Networking
    │   ├── Package.swift
    │   ├── Sources/Profile/
    │   │   ├── ProfileViewModel.swift
    │   │   └── Views/
    │   │       ├── ProfileView.swift          # Public profile
    │   │       ├── EditProfileView.swift      # Edit fields
    │   │       ├── EarningsDashboardView.swift # Helper earnings
    │   │       └── ReviewsListView.swift      # All reviews
    │   └── Tests/ProfileTests/
    │       └── ProfileViewModelTests.swift
    │
    └── Notifications/                      # 🔔 Depends on: DesignSystem, SharedModels, Networking
        ├── Package.swift
        ├── Sources/Notifications/
        │   ├── NotificationViewModel.swift
        │   └── Views/
        │       └── NotificationCenterView.swift
        └── Tests/NotificationsTests/
            └── NotificationViewModelTests.swift
```

---

## Module Contracts (Protocol Interfaces)

Each feature module receives its dependencies as **protocols**, injected at init. This makes every module testable with mocks and swappable with real implementations later.

```swift
// Example: TaskMarketplace doesn't know about Firebase.
// It only knows about TaskServiceProtocol.

public protocol TaskServiceProtocol: Sendable {
    func fetchNearbyTasks(latitude: Double, longitude: Double, radiusMiles: Double) async throws -> [AgentTask]
    func fetchTaskDetail(id: String) async throws -> AgentTask
    func applyForTask(taskId: String, note: String?) async throws
    func updateTaskStatus(taskId: String, status: TaskStatus) async throws
}

// In tests: inject MockTaskService (returns hardcoded data, no network)
// In app: inject FirebaseTaskService (hits Firestore)
// Swap anytime: inject AlgoliaTaskService, RESTTaskService, etc.
```

---

## Build Order (What I'll Create)

### Phase 1: Foundations (sequential — everything depends on these)

| Step | Module | Key Files | Tests |
|---|---|---|---|
| 1 | **DesignSystem** | AppColors, AppTypography, AppSpacing, PillButton, AATextField, AvatarView, RatingView, CategoryChip, TaskCard, EmptyStateView, LoadingView, StatusBadge | Component snapshot tests |
| 2 | **SharedModels** | User, AgentTask, TaskCategory, TaskStatus, Message, Conversation, Review, Payment, Badge, Notification + MockData (20+ users, 50+ tasks, messages, reviews) | Codable round-trip tests, model validation tests |
| 3 | **Networking** | 6 service protocols + 6 mock implementations | Mock service behavior tests |

### Phase 2: Features (parallel — no cross-dependencies)

| Module | Key Screens | ViewModel | Tests |
|---|---|---|---|
| **Authentication** | WelcomeView, OnboardingCarousel, SignInView, SignUpView, OTPVerificationView, ProfileSetupView | AuthViewModel (state machine: splash → onboarding → auth → setup → done) | Auth flow state tests |
| **TaskMarketplace** | TaskFeedView (list + map toggle), TaskDetailView, TaskFilterSheet | TaskListViewModel (fetch, filter, sort), TaskDetailViewModel (apply, status) | Filter/sort logic tests |
| **PostTask** | PostTaskFlow, CategorySelectView, TaskDetailsForm, TaskPricingView | PostTaskViewModel (multi-step form state, validation, submission) | Form validation tests |
| **Messaging** | ConversationListView, ChatView | ConversationListViewModel, ChatViewModel (send, receive, quick replies) | Message ordering tests |
| **Profile** | ProfileView, EditProfileView, EarningsDashboardView, ReviewsListView | ProfileViewModel (fetch, edit, earnings calc) | Earnings calculation tests |
| **Notifications** | NotificationCenterView | NotificationViewModel (fetch, mark read, badge count) | Notification state tests |

### Phase 3: App Shell (sequential — composes everything)

| File | Purpose |
|---|---|
| **AgentAssistApp.swift** | @main entry, environment setup |
| **AppDependencies.swift** | DI container: creates mock services, injects into ViewModels |
| **AppCoordinator.swift** | Auth state routing (logged out → auth flow, logged in → main tabs) |
| **ContentView.swift** | TabView: Home, Search, Post (+), Messages, Profile |

---

## Key Design Decisions

### 1. Protocol-based dependency injection (not framework DI)
No third-party DI framework. Simple protocol + init injection. Each ViewModel takes its service protocol in `init()`. The App Shell creates the concrete instances.

### 2. ViewModels are `@Observable` (iOS 17 Observation framework)
Using the modern `@Observable` macro instead of `ObservableObject` + `@Published`. Falls back to `ObservableObject` if targeting iOS 16.

### 3. Navigation via Coordinator pattern
Each feature module exposes a root `View`. The App Shell handles inter-module navigation (e.g., tapping a task card in the feed navigates to task detail, which is owned by TaskMarketplace internally).

### 4. Mock data is in SharedModels, not scattered
All mock/preview data lives in `SharedModels/MockData/`. Every module imports the same mocks for previews and tests. Single source of truth.

### 5. No singletons
No `shared` instances. Everything is created and passed explicitly. This ensures modules are sandboxed and testable.

### 6. Each module has a `*Module` entry point
Each feature exports a clean entry point view that accepts its dependencies:

```swift
// Public API of TaskMarketplace module
public struct TaskMarketplaceModule: View {
    public init(taskService: TaskServiceProtocol, currentUser: User) { ... }
    public var body: some View { TaskFeedView(...) }
}
```

The App Shell composes these:
```swift
TabView {
    TaskMarketplaceModule(taskService: deps.taskService, currentUser: user)
        .tabItem { Label("Home", systemImage: "house") }
    PostTaskModule(taskService: deps.taskService, currentUser: user)
        .tabItem { Label("Post", systemImage: "plus.circle.fill") }
    MessagingModule(messageService: deps.messageService, currentUser: user)
        .tabItem { Label("Chat", systemImage: "message") }
    ProfileModule(profileService: deps.profileService, currentUser: user)
        .tabItem { Label("Profile", systemImage: "person") }
}
```

---

## Agentic Engineering Properties

| Property | How It's Achieved |
|---|---|
| **Agent A works on DesignSystem** | Separate package, zero deps, own tests. No file conflicts with any feature work. |
| **Agent B works on TaskMarketplace** | Only touches `Packages/TaskMarketplace/`. Depends on DesignSystem + SharedModels via SPM, never imports their source directly. |
| **Agent C works on Messaging** | Same isolation. Can't conflict with Agent B because modules don't share files. |
| **Swap mock → Firebase** | Change one line in `AppDependencies.swift`: `MockTaskService()` → `FirebaseTaskService(db: firestore)`. Zero changes to feature modules. |
| **A/B test a new TaskCard** | Create `TaskCardV2` in DesignSystem. Feature modules reference it by name — swap at the component level. |
| **Run tests per module** | `cd Packages/TaskMarketplace && swift test` — tests only that module, fast feedback. |
| **Add a new feature module** | Create new package under `Packages/`, add protocols to Networking, add tab to App Shell. No existing modules change. |

---

## What Gets Built Now

- All ~55 Swift source files across 9 packages
- Full design system with 10 reusable components
- Complete mock data layer (20+ agents, 50+ tasks, conversations, reviews)
- 6 service protocols + 6 mock implementations
- Every screen in the MVP spec, wired to mock data
- Unit tests for every ViewModel
- App shell that composes everything into a working tab-based app
- Fully navigable from onboarding → task feed → task detail → post task → chat → profile

The app runs on Simulator immediately with mock data. When you hand over Firebase/Stripe keys, I swap the service layer — zero UI changes.
