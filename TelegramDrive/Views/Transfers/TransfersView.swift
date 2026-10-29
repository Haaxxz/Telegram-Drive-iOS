import SwiftUI

public struct TransfersView: View {
    @EnvironmentObject var state: AppState

    private var colors: ThemeColors {
        ThemeManager.colors(for: state.currentTheme)
    }

    public var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Transfers & Queue")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(colors.textPrimary)
                Spacer()
                if !state.transfers.isEmpty {
                    Button(action: {
                        state.clearCompletedTransfers()
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(colors.textDim)
                            .padding(8)
                            .background(colors.surfaceElevated)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 14)

            if state.transfers.isEmpty {
                // Empty state
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 42))
                        .foregroundColor(colors.textDim.opacity(0.5))
                    Text("No active transfers")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(colors.textPrimary)
                    Text("Upload or download files to view real MTProto chunk streaming progress here.")
                        .font(.system(size: 12))
                        .foregroundColor(colors.textDim)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(state.transfers) { task in
                            transferCard(task)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 90)
                }
            }
        }
        .background(colors.background.ignoresSafeArea())
    }

    private func transferCard(_ task: TransferTask) -> some View {
        let isDone = task.progress >= 1.0
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(task.fileName)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(colors.textPrimary)
                    .lineLimit(1)
                Spacer()
                Text(isDone ? "COMPLETED" : "\(Int(task.progress * 100))%")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(isDone ? colors.accentEmerald : colors.accentCyan)
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(colors.background)
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(isDone ? colors.accentEmerald : colors.accentCyan)
                        .frame(width: max(0, min(geo.size.width * CGFloat(task.progress), geo.size.width)), height: 6)
                        .animation(.linear(duration: 0.3), value: task.progress)
                }
            }
            .frame(height: 6)

            HStack {
                Text(task.status)
                    .font(.system(size: 11))
                    .foregroundColor(colors.textDim)
                Spacer()
                Text(task.formattedSize)
                    .font(.system(size: 11))
                    .foregroundColor(colors.textDim)
            }
        }
        .padding(12)
        .background(colors.surface)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(colors.border, lineWidth: 1))
    }
}
