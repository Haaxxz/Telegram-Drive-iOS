import SwiftUI

public struct FileDetailSheet: View {
    public let file: DriveFile
    public let colors: ThemeColors
    @EnvironmentObject var state: AppState
    @Environment(\.presentationMode) var presentationMode

    public var body: some View {
        VStack(spacing: 20) {
            // Drag handle
            Capsule()
                .fill(colors.textDim.opacity(0.4))
                .frame(width: 36, height: 4)
                .padding(.top, 10)

            // Header with Icon & Name
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(file.themeColor.opacity(0.18))
                        .frame(width: 52, height: 52)
                    Image(systemName: file.kind.iconName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(file.themeColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(file.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(colors.textPrimary)
                        .lineLimit(2)
                    Text("\(file.formattedSize) · Uploaded \(file.date)")
                        .font(.system(size: 12))
                        .foregroundColor(colors.textSecondary)
                }
                Spacer()
            }
            .padding(.horizontal)

            // Primary Action Buttons
            HStack(spacing: 12) {
                Button(action: {
                    state.downloadFile(file)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                        Text("Download")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(colors.accentCyan)
                    .cornerRadius(12)
                }

                Button(action: {
                    UIPasteboard.general.string = "tg://resolve?domain=telegramdrive&msg=\(file.msgId)"
                    state.showToast("Telegram message link copied")
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(colors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(colors.surfaceElevated)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)

            // File Details Card
            VStack(spacing: 10) {
                detailRow(label: "Storage Location", value: file.chat, valueColor: colors.textPrimary)
                Divider().background(colors.border)
                detailRow(
                    label: "Encryption",
                    value: file.isVault ? "TDENC2 Zero-Knowledge AES-GCM" : "Standard Telegram Cloud",
                    valueColor: file.isVault ? colors.accentEmerald : colors.textSecondary
                )
                Divider().background(colors.border)
                detailRow(label: "Telegram Message ID", value: "#\(file.msgId)", valueColor: colors.textDim)
            }
            .padding(14)
            .background(colors.surfaceElevated)
            .cornerRadius(14)
            .padding(.horizontal)

            // Delete Button
            Button(action: {
                state.deleteFile(file)
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("Delete from Telegram Cloud")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(colors.accentRose)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(colors.accentRose.opacity(0.12))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(colors.surface.ignoresSafeArea())
    }

    private func detailRow(label: String, value: String, valueColor: Color) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(colors.textDim)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(valueColor)
        }
    }
}
