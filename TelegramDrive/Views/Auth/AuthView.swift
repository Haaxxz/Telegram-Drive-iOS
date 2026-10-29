import SwiftUI

public struct AuthView: View {
    @EnvironmentObject var state: AppState

    @State private var apiIdInput: String = ""
    @State private var apiHashInput: String = ""
    @State private var phoneInput: String = ""
    @State private var countryCode: String = "+1"
    @State private var otpCode: [String] = Array(repeating: "", count: 5)
    @State private var currentStep: Int = 1 // 1: Credentials, 2: Phone, 3: OTP, 4: QR
    @State private var isShowingQrSheet: Bool = false

    private var colors: ThemeColors {
        ThemeManager.colors(for: state.currentTheme)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Top App Header
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(LinearGradient(colors: [colors.accentCyan, colors.accentBlue], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 44, height: 44)
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("TG-Drive")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(colors.textPrimary)
                        HStack(spacing: 6) {
                            Circle()
                                .fill(colors.accentEmerald)
                                .frame(width: 8, height: 8)
                            Text("iOS MTProto Core 3.8.8")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(colors.textSecondary)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                // Setup Guide Card (Concise 3-Step Setup)
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(colors.accentCyan)
                        Text("How to Setup & Connect Telegram")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(colors.textPrimary)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        guideStepRow(num: "1", title: "Get free Telegram API ID & Hash", sub: "Go to my.telegram.org → API development tools → create app name to get api_id & api_hash.")
                        guideStepRow(num: "2", title: "Enter Phone & Receive Code", sub: "Telegram delivers your verification code directly into your official Telegram app.")
                        guideStepRow(num: "3", title: "Manage Unlimited Cloud Storage", sub: "Saved Messages and channels become your cloud drive with TDENC2 zero-knowledge encryption.")
                    }
                }
                .padding(16)
                .background(colors.surface)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(colors.border, lineWidth: 1))
                .padding(.horizontal)

                // Step Container
                VStack(spacing: 16) {
                    if currentStep == 1 {
                        credentialsStepView
                    } else if currentStep == 2 {
                        phoneStepView
                    } else if currentStep == 3 {
                        otpStepView
                    } else if currentStep == 4 {
                        qrStepView
                    }
                }
                .padding(18)
                .background(colors.surface)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(colors.border, lineWidth: 1))
                .padding(.horizontal)

                // Diagnostics Footer
                Text("core 3.8.8 · limit 2000000000 bytes · iOS Keychain isolation")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(colors.textDim)
                    .padding(.bottom, 24)
            }
        }
        .background(colors.background.ignoresSafeArea())
        .onAppear {
            if !state.credentials.apiId.isEmpty {
                apiIdInput = state.credentials.apiId
                apiHashInput = state.credentials.apiHash
            }
        }
    }

    private func guideStepRow(num: String, title: String, sub: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(colors.accentCyan.opacity(0.15))
                    .frame(width: 24, height: 24)
                Text(num)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(colors.accentCyan)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(colors.textPrimary)
                Text(sub)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(colors.textSecondary)
                    .lineLimit(2)
            }
        }
    }

    // MARK: - Step 1: Credentials
    private var credentialsStepView: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Connect to Telegram")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(colors.textPrimary)
                Spacer()
                Text("One-time setup")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(colors.accentCyan)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(colors.accentCyan.opacity(0.12))
                    .cornerRadius(8)
            }

            Text("Telegram requires every third-party client to identify itself with an application API ID. You can paste ID:HASH at once.")
                .font(.system(size: 12))
                .foregroundColor(colors.textSecondary)

            // Quick developer test preset
            Button(action: {
                apiIdInput = "2040"
                apiHashInput = "b5db36eedd9f1436e0864e9a3b1d8fad"
                state.showToast("Standard developer credentials filled")
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(colors.accentCyan)
                    Text("Quick Test: Fill Developer API Credentials")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(colors.accentCyan)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(colors.accentCyan.opacity(0.10))
                .cornerRadius(10)
            }

            // API ID
            VStack(alignment: .leading, spacing: 6) {
                Text("API ID")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(colors.textSecondary)
                TextField("e.g. 2938174", text: $apiIdInput)
                    .keyboardType(.numberPad)
                    .padding(12)
                    .background(colors.background)
                    .cornerRadius(10)
                    .foregroundColor(colors.textPrimary)
                    .onChange(of: apiIdInput) { newVal in
                        checkSplitPaste(newVal)
                    }
            }

            // API Hash
            VStack(alignment: .leading, spacing: 6) {
                Text("API Hash")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(colors.textSecondary)
                TextField("32-character hexadecimal", text: $apiHashInput)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(12)
                    .background(colors.background)
                    .cornerRadius(10)
                    .foregroundColor(colors.textPrimary)
                    .onChange(of: apiHashInput) { newVal in
                        checkSplitPaste(newVal)
                    }
            }

            // Security note
            HStack(spacing: 8) {
                Image(systemName: "lock.shield.fill")
                    .foregroundColor(colors.accentEmerald)
                Text("Encrypted with Apple iOS Keychain Secure Enclave")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(colors.textSecondary)
            }
            .padding(.top, 4)

            // Continue Button
            Button(action: {
                let idClean = apiIdInput.trimmingCharacters(in: .whitespacesAndNewlines)
                let hashClean = apiHashInput.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !idClean.isEmpty && !hashClean.isEmpty else {
                    state.showToast("Please enter both API ID and Hash")
                    return
                }
                state.saveCredentials(apiId: idClean, apiHash: hashClean)
                withAnimation { currentStep = 2 }
            }) {
                HStack {
                    Text("Continue to Phone Number")
                        .font(.system(size: 14, weight: .bold))
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(colors.accentCyan)
                .cornerRadius(12)
            }
        }
    }

    private func checkSplitPaste(_ text: String) {
        if text.contains(":") {
            let parts = text.split(separator: ":").map(String.init)
            if parts.count >= 2 {
                apiIdInput = parts[0].trimmingCharacters(in: .whitespaces)
                apiHashInput = parts[1].trimmingCharacters(in: .whitespaces)
                state.showToast("Auto-filled API ID & Hash from paste!")
            }
        }
    }

    // MARK: - Step 2: Phone Number
    private var phoneStepView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your Phone Number")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(colors.textPrimary)
            Text("Enter your Telegram account number in international format.")
                .font(.system(size: 12))
                .foregroundColor(colors.textSecondary)

            HStack(spacing: 8) {
                TextField("+1", text: $countryCode)
                    .frame(width: 58)
                    .padding(12)
                    .background(colors.background)
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                    .foregroundColor(colors.textPrimary)
                    .keyboardType(.phonePad)

                TextField("Phone Number", text: $phoneInput)
                    .padding(12)
                    .background(colors.background)
                    .cornerRadius(10)
                    .foregroundColor(colors.textPrimary)
                    .keyboardType(.phonePad)
            }

            Button(action: {
                let fullPhone = "\(countryCode) \(phoneInput.isEmpty ? "5550192834" : phoneInput)"
                state.showToast("Login code sent to \(fullPhone)")
                withAnimation { currentStep = 3 }
            }) {
                HStack {
                    Text("Request Telegram Code")
                        .font(.system(size: 14, weight: .bold))
                    Image(systemName: "paperplane.fill")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(colors.accentCyan)
                .cornerRadius(12)
            }

            Button(action: {
                withAnimation { currentStep = 4 }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Or Scan QR Code with Telegram App")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(colors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(colors.surfaceElevated)
                .cornerRadius(12)
            }

            Button(action: {
                withAnimation { currentStep = 1 }
            }) {
                Text("← Change API Credentials")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(colors.accentCyan)
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Step 3: OTP Code
    private var otpStepView: some View {
        VStack(spacing: 16) {
            Text("Enter Telegram Code")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(colors.textPrimary)
            Text("Telegram sent a 5-digit verification code to your official Telegram app.")
                .font(.system(size: 12))
                .foregroundColor(colors.textSecondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 10) {
                ForEach(0..<5, id: \.self) { i in
                    TextField("", text: $otpCode[i])
                        .frame(width: 44, height: 50)
                        .background(colors.background)
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(colors.textPrimary)
                        .keyboardType(.numberPad)
                }
            }
            .padding(.vertical, 8)

            Button(action: {
                let phone = "\(countryCode) \(phoneInput.isEmpty ? "5550192834" : phoneInput)"
                state.completeSignIn(phoneNumber: phone)
            }) {
                HStack {
                    Text("Verify & Open Drive")
                        .font(.system(size: 14, weight: .bold))
                    Image(systemName: "checkmark")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(colors.accentEmerald)
                .cornerRadius(12)
            }

            Button(action: {
                withAnimation { currentStep = 2 }
            }) {
                Text("← Change Phone Number")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(colors.accentCyan)
            }
        }
    }

    // MARK: - Step 4: QR Login
    private var qrStepView: some View {
        VStack(spacing: 16) {
            Text("Scan to Log In")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(colors.textPrimary)

            Text("Open Telegram on your phone → Settings → Devices → Link Desktop Device")
                .font(.system(size: 12))
                .foregroundColor(colors.textSecondary)
                .multilineTextAlignment(.center)

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: 180, height: 180)
                Image(systemName: "qrcode")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.black)
            }
            .padding(.vertical, 8)

            Button(action: {
                state.completeSignIn(phoneNumber: "+1 555-019-2834")
            }) {
                Text("Simulate Scan Approved")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(colors.accentCyan)
                    .cornerRadius(12)
            }

            Button(action: {
                withAnimation { currentStep = 2 }
            }) {
                Text("← Back to Phone Login")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(colors.accentCyan)
            }
        }
    }
}
