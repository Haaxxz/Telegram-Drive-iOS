import SwiftUI

public struct ThemeColors {
    public let background: Color
    public let surface: Color
    public let surfaceElevated: Color
    public let border: Color
    public let textPrimary: Color
    public let textSecondary: Color
    public let textDim: Color
    public let accentCyan: Color
    public let accentEmerald: Color
    public let accentBlue: Color
    public let accentPurple: Color
    public let accentRose: Color
}

public struct ThemeManager {
    public static func colors(for theme: AppTheme) -> ThemeColors {
        switch theme {
        case .dark:
            return ThemeColors(
                background: Color(red: 0.04, green: 0.05, blue: 0.08),
                surface: Color(red: 0.08, green: 0.11, blue: 0.17),
                surfaceElevated: Color(red: 0.11, green: 0.15, blue: 0.23),
                border: Color.white.opacity(0.08),
                textPrimary: Color(red: 0.97, green: 0.98, blue: 0.99),
                textSecondary: Color(red: 0.58, green: 0.64, blue: 0.72),
                textDim: Color(red: 0.39, green: 0.45, blue: 0.55),
                accentCyan: Color(red: 0.02, green: 0.71, blue: 0.83),
                accentEmerald: Color(red: 0.06, green: 0.73, blue: 0.51),
                accentBlue: Color(red: 0.23, green: 0.51, blue: 0.96),
                accentPurple: Color(red: 0.55, green: 0.36, blue: 0.96),
                accentRose: Color(red: 0.96, green: 0.25, blue: 0.37)
            )
        case .light:
            return ThemeColors(
                background: Color(red: 0.96, green: 0.97, blue: 0.99),
                surface: Color.white,
                surfaceElevated: Color(red: 0.93, green: 0.95, blue: 0.97),
                border: Color.black.opacity(0.08),
                textPrimary: Color(red: 0.06, green: 0.09, blue: 0.16),
                textSecondary: Color(red: 0.35, green: 0.40, blue: 0.49),
                textDim: Color(red: 0.55, green: 0.60, blue: 0.69),
                accentCyan: Color(red: 0.03, green: 0.65, blue: 0.76),
                accentEmerald: Color(red: 0.05, green: 0.65, blue: 0.45),
                accentBlue: Color(red: 0.20, green: 0.45, blue: 0.90),
                accentPurple: Color(red: 0.50, green: 0.32, blue: 0.90),
                accentRose: Color(red: 0.90, green: 0.20, blue: 0.32)
            )
        case .cyberpunk:
            return ThemeColors(
                background: Color(red: 0.05, green: 0.02, blue: 0.09),
                surface: Color(red: 0.10, green: 0.04, blue: 0.18),
                surfaceElevated: Color(red: 0.15, green: 0.06, blue: 0.25),
                border: Color(red: 1.0, green: 0.0, blue: 0.5).opacity(0.3),
                textPrimary: Color(red: 0.99, green: 0.98, blue: 1.0),
                textSecondary: Color(red: 0.85, green: 0.70, blue: 0.95),
                textDim: Color(red: 0.65, green: 0.45, blue: 0.75),
                accentCyan: Color(red: 0.0, green: 0.95, blue: 0.98),
                accentEmerald: Color(red: 0.0, green: 1.0, blue: 0.55),
                accentBlue: Color(red: 0.25, green: 0.60, blue: 1.0),
                accentPurple: Color(red: 0.80, green: 0.20, blue: 1.0),
                accentRose: Color(red: 1.0, green: 0.08, blue: 0.58)
            )
        case .emerald:
            return ThemeColors(
                background: Color(red: 0.02, green: 0.08, blue: 0.06),
                surface: Color(red: 0.04, green: 0.14, blue: 0.10),
                surfaceElevated: Color(red: 0.06, green: 0.20, blue: 0.15),
                border: Color(red: 0.06, green: 0.73, blue: 0.51).opacity(0.25),
                textPrimary: Color(red: 0.95, green: 0.99, blue: 0.97),
                textSecondary: Color(red: 0.65, green: 0.85, blue: 0.75),
                textDim: Color(red: 0.40, green: 0.65, blue: 0.55),
                accentCyan: Color(red: 0.02, green: 0.85, blue: 0.75),
                accentEmerald: Color(red: 0.10, green: 0.85, blue: 0.55),
                accentBlue: Color(red: 0.15, green: 0.70, blue: 0.85),
                accentPurple: Color(red: 0.45, green: 0.85, blue: 0.65),
                accentRose: Color(red: 0.95, green: 0.35, blue: 0.45)
            )
        }
    }
}
