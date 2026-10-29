import SwiftUI

public struct FileListRow: View {
    public let file: DriveFile
    public let isSelected: Bool
    public let colors: ThemeColors
    public let onTap: () -> Void
    public let onLongPress: () -> Void

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Leading icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(file.themeColor.opacity(0.18))
                        .frame(width: 42, height: 42)
                    Image(systemName: file.kind.iconName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(file.themeColor)
                }

                // File metadata
                VStack(alignment: .leading, spacing: 3) {
                    Text(file.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(colors.textPrimary)
                        .lineLimit(1)

                    HStack(spacing: 6) {
                        Text(file.formattedSize)
                        Text("·")
                        Text(file.date)
                        if file.isVault {
                            Text("· Encrypted")
                                .foregroundColor(colors.accentEmerald)
                        }
                    }
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(colors.textDim)
                }

                Spacer()

                // Trailing menu icon
                Image(systemName: "ellipsis")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(colors.textDim)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(colors.surface)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? colors.accentCyan : colors.border, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(LongPressGesture().onEnded { _ in onLongPress() })
    }
}
