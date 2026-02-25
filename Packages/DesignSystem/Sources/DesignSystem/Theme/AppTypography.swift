import SwiftUI

// MARK: - View Modifiers

/// Large title style — 34pt bold, deep navy.
public struct LargeTitleModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 34, weight: .bold))
            .foregroundStyle(AppColors.deepNavy)
    }
}

/// Title style — 24pt bold, deep navy.
public struct TitleModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(AppColors.deepNavy)
    }
}

/// Headline style — 17pt semibold, deep navy.
public struct HeadlineModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(AppColors.deepNavy)
    }
}

/// Body style — 17pt regular, deep navy.
public struct BodyModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(AppColors.deepNavy)
    }
}

/// Callout style — 15pt medium, soft gray.
public struct CalloutModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(AppColors.softGray)
    }
}

/// Caption style — 13pt regular, soft gray.
public struct CaptionModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 13, weight: .regular))
            .foregroundStyle(AppColors.softGray)
    }
}

// MARK: - View Extensions

public extension View {

    /// Applies large title typography — 34pt bold, deep navy.
    func largeTitleStyle() -> some View {
        modifier(LargeTitleModifier())
    }

    /// Applies title typography — 24pt bold, deep navy.
    func titleStyle() -> some View {
        modifier(TitleModifier())
    }

    /// Applies headline typography — 17pt semibold, deep navy.
    func headlineStyle() -> some View {
        modifier(HeadlineModifier())
    }

    /// Applies body typography — 17pt regular, deep navy.
    func bodyStyle() -> some View {
        modifier(BodyModifier())
    }

    /// Applies callout typography — 15pt medium, soft gray.
    func calloutStyle() -> some View {
        modifier(CalloutModifier())
    }

    /// Applies caption typography — 13pt regular, soft gray.
    func captionStyle() -> some View {
        modifier(CaptionModifier())
    }
}
