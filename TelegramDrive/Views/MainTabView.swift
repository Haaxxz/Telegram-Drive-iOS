import SwiftUI

public struct MainTabView: View {
    @EnvironmentObject var state: AppState
    @State private var selectedTab: Int = 0

    private var colors: ThemeColors {
        ThemeManager.colors(for: state.currentTheme)
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Viewport
            Group {
                switch selectedTab {
                case 0:
                    AuthView()
                case 1:
                    DriveView()
                case 2:
                    TransfersView()
                case 3:
                    SettingsView()
                default:
                    AuthView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom Glassmorphic Bottom Dock
            bottomNavDock

            // Toast Notice Overlay
            if let msg = state.toastMessage {
                toastView(msg)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(100)
            }
        }
        .onAppear {
            selectedTab = state.signedIn ? 1 : 0
        }
        .onChange(of: state.signedIn) { signedIn in
            withAnimation {
                selectedTab = signedIn ? 1 : 0
            }
        }
    }

    // MARK: - Bottom Navigation Dock
    private var bottomNavDock: some View {
        HStack {
            navItem(index: 0, title: "Sign In", icon: "arrow.right.to.line.compact")
            Spacer()
            navItem(index: 1, title: "Drive", icon: "folder.fill")
            Spacer()
            navItem(index: 2, title: "Transfers", icon: "arrow.triangle.2.circlepath")
            Spacer()
            navItem(index: 3, title: "Settings", icon: "gearshape.fill")
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 10)
        .background(colors.surface.opacity(0.96))
        .cornerRadius(26)
        .overlay(RoundedRectangle(cornerRadius: 26).stroke(colors.border, lineWidth: 1))
        .shadow(color: Color.black.opacity(0.3), radius: 15, y: 5)
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }

    private func navItem(index: Int, title: String, icon: String) -> some View {
        let isSelected = selectedTab == index
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(colors.accentCyan.opacity(0.2))
                            .frame(width: 48, height: 28)
                    }
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? colors.accentCyan : colors.textDim)
                }
                Text(title)
                    .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? colors.accentCyan : colors.textDim)
            }
        }
    }

    // MARK: - Toast View
    private func toastView(_ message: String) -> some View {
        VStack {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(colors.accentEmerald)
                Text(message)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(red: 0.1, green: 0.12, blue: 0.18).opacity(0.95))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(colors.accentCyan.opacity(0.3), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.4), radius: 10, y: 5)
            .padding(.top, 48)

            Spacer()
        }
    }
}
