import SwiftUI

/// A styled text field with label, placeholder, optional secure entry,
/// and inline error messaging.
///
/// ```swift
/// AATextField(
///     label: "Email",
///     text: $email,
///     placeholder: "you@example.com",
///     errorMessage: emailError
/// )
/// ```
public struct AATextField: View {

    // MARK: - Properties

    private let label: String
    @Binding private var text: String
    private let placeholder: String
    private let isSecure: Bool
    private let errorMessage: String?

    @FocusState private var isFocused: Bool

    // MARK: - Init

    public init(
        label: String,
        text: Binding<String>,
        placeholder: String,
        isSecure: Bool = false,
        errorMessage: String? = nil
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.errorMessage = errorMessage
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxs) {
            // Label
            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AppColors.deepNavy)

            // Input field
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.system(size: 17))
            .foregroundStyle(AppColors.deepNavy)
            .padding(.horizontal, AppSpacing.sm)
            .frame(height: 48)
            .background(AppColors.freshWhite)
            .clipShape(RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small))
            .overlay {
                RoundedRectangle(cornerRadius: AppSpacing.CornerRadius.small)
                    .strokeBorder(borderColor, lineWidth: isFocused ? 1.5 : 1)
            }
            .focused($isFocused)

            // Error message
            if let errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(AppColors.errorRed)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }

    // MARK: - Helpers

    private var borderColor: Color {
        if errorMessage != nil {
            return AppColors.errorRed
        }
        return isFocused ? AppColors.deepNavy : AppColors.lightGray
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: AppSpacing.lg) {
        AATextField(
            label: "Email",
            text: .constant(""),
            placeholder: "you@example.com"
        )

        AATextField(
            label: "Password",
            text: .constant("secret"),
            placeholder: "Enter password",
            isSecure: true
        )

        AATextField(
            label: "Phone Number",
            text: .constant("555"),
            placeholder: "(555) 555-5555",
            errorMessage: "Please enter a valid phone number"
        )
    }
    .padding(AppSpacing.md)
}
