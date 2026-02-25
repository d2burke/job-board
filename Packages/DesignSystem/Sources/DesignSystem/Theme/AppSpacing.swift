import SwiftUI

/// Spacing tokens built on a 4-point grid.
///
/// Use these values for padding, margins, gaps, and other spatial
/// relationships so the UI stays consistent throughout the app.
public struct AppSpacing {

    // MARK: - Spacing (4pt grid)

    /// 2pt — extra extra extra small.
    public static let xxxs: CGFloat = 2

    /// 4pt — extra extra small.
    public static let xxs: CGFloat = 4

    /// 8pt — extra small.
    public static let xs: CGFloat = 8

    /// 12pt — small.
    public static let sm: CGFloat = 12

    /// 16pt — medium (base).
    public static let md: CGFloat = 16

    /// 24pt — large.
    public static let lg: CGFloat = 24

    /// 32pt — extra large.
    public static let xl: CGFloat = 32

    /// 48pt — extra extra large.
    public static let xxl: CGFloat = 48

    /// 64pt — extra extra extra large.
    public static let xxxl: CGFloat = 64

    // MARK: - Corner Radii

    /// Corner radius tokens following the same design language.
    public struct CornerRadius {

        /// 8pt corner radius — cards, inputs.
        public static let small: CGFloat = 8

        /// 12pt corner radius — modals, sheets.
        public static let medium: CGFloat = 12

        /// 16pt corner radius — larger containers.
        public static let large: CGFloat = 16

        /// 24pt corner radius — pill shapes, tags.
        public static let pill: CGFloat = 24

        private init() {}
    }

    private init() {}
}
