import SwiftUI

/// A circular avatar image with optional verification badge.
///
/// Uses `AsyncImage` to load from a URL string. Falls back to a
/// `person.fill` system image placeholder when `url` is `nil` or
/// the image fails to load.
///
/// ```swift
/// AvatarView(url: "https://example.com/photo.jpg", size: 56, showBadge: true)
/// ```
public struct AvatarView: View {

    // MARK: - Properties

    private let url: String?
    private let size: CGFloat
    private let showBadge: Bool

    // MARK: - Init

    public init(
        url: String? = nil,
        size: CGFloat = 44,
        showBadge: Bool = false
    ) {
        self.url = url
        self.size = size
        self.showBadge = showBadge
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarImage
                .frame(width: size, height: size)
                .clipShape(Circle())

            if showBadge {
                badgeOverlay
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var avatarImage: some View {
        if let url, let imageURL = URL(string: url) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    placeholderView
                case .empty:
                    placeholderView
                        .overlay {
                            ProgressView()
                                .tint(AppColors.softGray)
                        }
                @unknown default:
                    placeholderView
                }
            }
        } else {
            placeholderView
        }
    }

    private var placeholderView: some View {
        Circle()
            .fill(AppColors.lightGray)
            .overlay {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(size * 0.25)
                    .foregroundStyle(AppColors.softGray)
            }
    }

    private var badgeOverlay: some View {
        let badgeSize = size * 0.32
        return Image(systemName: "checkmark.circle.fill")
            .resizable()
            .frame(width: badgeSize, height: badgeSize)
            .foregroundStyle(.white, .blue)
            .background(
                Circle()
                    .fill(.white)
                    .frame(width: badgeSize + 2, height: badgeSize + 2)
            )
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: AppSpacing.md) {
        AvatarView(size: 44)
        AvatarView(size: 56, showBadge: true)
        AvatarView(url: "https://picsum.photos/200", size: 64, showBadge: true)
        AvatarView(url: "https://invalid-url", size: 44)
    }
    .padding(AppSpacing.md)
}
