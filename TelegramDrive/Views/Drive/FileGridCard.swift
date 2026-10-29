import SwiftUI

public struct FileGridCard: View {
    public let file: DriveFile
    public let isSelected: Bool
    public let colors: ThemeColors
    public let onTap: () -> Void
    public let onLongPress: () -> Void

    public var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Preview thumbnail / Icon
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors.surfaceElevated)
                        .frame(height: 100)

                    // Ext Badge
                    Text(file.ext)
                        .font(.system(size: 9, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(file.themeColor)
                        .cornerRadius(6)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)

                    // Vault lock badge
                    if file.isVault {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(colors.accentEmerald)
                            .padding(8)
                    }

                    // Main icon
                    Image(systemName: file.kind.iconName)
                        .font(.system(size: 32))
                        .foregroundColor(file.themeColor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // File Info
                VStack(alignment: .leading, spacing: 3) {
                    Text(file.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(colors.textPrimary)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Text(file.formattedSize)
                        Text("·")
                        Text(file.date)
                    }
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(colors.textDim)
                }
            }
            .padding(10)
            .background(colors.surface)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? colors.accentCyan : colors.border, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(LongPressGesture().onEnded { _ in onLongPress() })
    }
}
