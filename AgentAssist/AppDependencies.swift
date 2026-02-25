import Foundation
import Observation
import Networking

@Observable
final class AppDependencies {
    let authService: MockAuthService
    let taskService: MockTaskService
    let messageService: MockMessageService
    let paymentService: MockPaymentService
    let profileService: MockProfileService
    let notificationService: MockNotificationService

    init() {
        self.authService = MockAuthService()
        self.taskService = MockTaskService()
        self.messageService = MockMessageService()
        self.paymentService = MockPaymentService()
        self.profileService = MockProfileService()
        self.notificationService = MockNotificationService()
    }
}
