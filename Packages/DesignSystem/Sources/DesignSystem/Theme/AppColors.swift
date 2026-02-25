import SwiftUI

/// Central color palette for the AgentAssist design system.
///
/// All colors are defined as static properties so they can be referenced
/// throughout the app without instantiating the struct.
public struct AppColors {

    // MARK: - Brand

    /// Primary brand color — deep navy blue.
    public static let deepNavy = Color(red: 0.08, green: 0.10, blue: 0.22)

    /// Call-to-action color — warm coral.
    public static let warmCoral = Color(red: 0.96, green: 0.34, blue: 0.28)

    // MARK: - Neutrals

    /// Primary background color — fresh white.
    public static let freshWhite = Color(red: 0.98, green: 0.98, blue: 0.99)

    /// Secondary text color — soft gray.
    public static let softGray = Color(red: 0.55, green: 0.58, blue: 0.63)

    /// Card backgrounds and borders — light gray.
    public static let lightGray = Color(red: 0.93, green: 0.94, blue: 0.95)

    // MARK: - Semantic

    /// Success state color — green.
    public static let successGreen = Color(red: 0.20, green: 0.78, blue: 0.35)

    /// Warning state color — amber.
    public static let warningAmber = Color(red: 1.00, green: 0.76, blue: 0.03)

    /// Error state color — red.
    public static let errorRed = Color(red: 0.90, green: 0.22, blue: 0.21)

    // MARK: - Accent

    /// Star ratings and highlights — gold.
    public static let accentGold = Color(red: 0.93, green: 0.73, blue: 0.22)

    private init() {}
}
