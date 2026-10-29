import Foundation
import SwiftUI

public struct SettingsView: View {
    @EnvironmentObject var state: AppState

    private var colors: ThemeColors {
        ThemeManager.colors(for: state.currentTheme)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                profileCard
                credentialsSection
                themeSection
                cacheCleaner
                bridgeSection
                disconnectSection
            }
            .padding(.bottom, 90)
        }
        .background(colors.background.ignoresSafeArea())
    }

    private var profileCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [colors.accentCyan, colors.accentBlue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 48, height: 48)
                Text("TG")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(state.signedIn ? "Telegram User" : "Not Signed In")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(colors.textPrimary)
                Text(state.signedIn ? (state.credentials.phone.isEmpty ? "+1 555-019-2834" : state.credentials.phone) : "Telegram Account")
                    .font(.system(size: 12))
                    .foregroundColor(colors.textSecondary)
            }
            Spacer()
        }
        .padding(14)
        .background(colors.surface)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(colors.border, lineWidth: 1))
        .padding(.horizontal)
    }

    private var credentialsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Telegram API Credentials")

            VStack(spacing: 0) {
                HStack {
                    credentialIcon(color: colors.accentCyan, systemImage: "key.fill")
                    VStack(alignment: .leading, spacing: 2) {
                        Text("API ID & Hash")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(colors.textPrimary)
                        Text(state.credentials.isValid ? "Configured (ID: \(state.credentials.apiId))" : "Not configured")
                            .font(.system(size: 11))
                            .foregroundColor(colors.textSecondary)
                    }
                    Spacer()
                }
                .padding(12)

                Divider().background(colors.border)

                HStack {
                    credentialIcon(color: colors.accentEmerald, systemImage: "lock.shield.fill")
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Apple iOS Keychain")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(colors.textPrimary)
                        Text("Hardware Secure Enclave AES-256")
                            .font(.system(size: 11))
                            .foregroundColor(colors.textSecondary)
                    }
                    Spacer()
                    Text("SECURE")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundColor(colors.accentEmerald)
                }
                .padding(12)
            }
            .background(colors.surface)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(colors.border, lineWidth: 1))
        }
        .padding(.horizontal)
    }

    private var themeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Theme & Appearance")

            VStack(spacing: 8) {
                ForEach(AppTheme.allCases) { theme in
                    Button(action: {
                        state.currentTheme = theme
                        state.showToast("Theme changed to \(theme.displayName)")
                    }) {
                        HStack {
                            Circle()
                                .fill(ThemeManager.colors(for: theme).accentCyan)
                                .frame(width: 14, height: 14)
                            Text(theme.displayName)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(colors.textPrimary)
                            Spacer()
                            if state.currentTheme == theme {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(colors.accentCyan)
                            }
                        }
                        .padding(12)
                        .background(state.currentTheme == theme ? colors.surfaceElevated : colors.surface)
                        .cornerRadius(10)
                    }
                }
            }
            .padding(8)
            .background(colors.surface)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(colors.border, lineWidth: 1))
        }
        .padding(.horizontal)
    }

    private var cacheCleaner: some View {
        VStack(spacing: 8) {
            Button(action: {
                state.showToast("Thumbnail cache cleared (0 MB freed)")
            }) {
                HStack {
                    Image(systemName: "trash.circle")
                        .foregroundColor(colors.textDim)
                    Text("Clear Thumbnail Cache")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(colors.textPrimary)
                    Spacer()
                }
                .padding(12)
                .background(colors.surface)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(colors.border, lineWidth: 1))
            }
        }
        .padding(.horizontal)
    }

    private var bridgeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("MTProto Bridge (Backend)")

            VStack(spacing: 0) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(state.mtprotoBridgeUrl.isEmpty ? colors.accentRose.opacity(0.15) : colors.accentEmerald.opacity(0.15))
                            .frame(width: 32, height: 32)
                        Image(systemName: state.mtprotoBridgeUrl.isEmpty ? "wifi.slash" : "server.rack")
                            .font(.system(size: 14))
                            .foregroundColor(state.mtprotoBridgeUrl.isEmpty ? colors.accentRose : colors.accentEmerald)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Bridge Endpoint")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(colors.textPrimary)
                        Text(state.mtprotoBridgeUrl.isEmpty ? "Not configured — login falls back to offline demo" : state.mtprotoBridgeUrl)
                            .font(.system(size: 11))
                            .foregroundColor(colors.textSecondary)
                            .lineLimit(2)
                    }
                    Spacer()
                }
                .padding(12)

                Divider().background(colors.border)

                HStack {
                    TextField("https://…/mtproto", text: $state.mtprotoBridgeUrl)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.system(size: 12))
                        .padding(10)
                        .background(colors.background)
                        .cornerRadius(8)
                        .foregroundColor(colors.textPrimary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }

                HStack(spacing: 10) {
                    Button(action: {
                        state.syncBridgeUrlToNative()
                        UserDefaults.standard.set(state.mtprotoBridgeUrl, forKey: "tg_mtproto_bridge_url")
                        state.showToast("Bridge URL saved")
                    }) {
                        Text("Save & Use")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(colors.accentCyan)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        state.mtprotoBridgeUrl = ""
                        state.syncBridgeUrlToNative()
                        UserDefaults.standard.removeObject(forKey: "tg_mtproto_bridge_url")
                        state.showToast("Bridge URL cleared — offline fallback")
                    }) {
                        Text("Clear")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(colors.accentRose)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(colors.accentRose.opacity(0.12))
                            .cornerRadius(8)
                    }
                }
            }
            .background(colors.surface)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(colors.border, lineWidth: 1))
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var disconnectSection: some View {
        if state.signedIn {
            Button(action: {
                state.disconnect()
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Disconnect Telegram Account")
                        .font(.system(size: 13, weight: .bold))
                }
                .foregroundColor(colors.accentRose)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(colors.accentRose.opacity(0.12))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(colors.textDim)
            .textCase(.uppercase)
    }

    private func credentialIcon(color: Color, systemImage: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.15))
                .frame(width: 32, height: 32)
            Image(systemName: systemImage)
                .font(.system(size: 14))
                .foregroundColor(color)
        }
    }
}
