# Telegram Drive for iOS

Native iOS client for **Telegram Drive** built in modern Swift and SwiftUI. Mirrors the Android client architecture 1:1, sharing identical MTProto core operations, zero placeholder data, interactive 3-step Telegram onboarding, live chunked streaming transfer queue, and client-side zero-knowledge AES-256-GCM vault encryption (`TDENC2`).

## Architecture & Parity with Android

| Layer | Android Client | iOS Port (`Telegram-Drive-iOS`) |
| :--- | :--- | :--- |
| **Language & UI** | Kotlin + Jetpack Compose | Swift 5.9+ + SwiftUI |
| **Core Bridge** | `TDNative.call(operation, argsJson)` (JNI) | `TDNative.call(operation, argsJson)` (C-ABI / FFI) |
| **State Management** | `AppViewModel` (Kotlin Coroutines / StateFlow) | `AppState` (ObservableObject / Combine) |
| **Secret Storage** | Android Keystore Hardware AES-GCM | Apple iOS Keychain + Secure Enclave |
| **Biometric Auth** | Android BiometricPrompt | LocalAuthentication (`Face ID` / `Touch ID`) |
| **File Intake** | Android Document Picker / Intent filter | iOS `fileImporter` + Security Scoped URLs |
| **Design System** | Material 3 + Glassmorphic obsidian | SwiftUI Glassmorphism + Material (Dark / Light / Cyberpunk / Emerald) |

## Project Structure

```
Telegram-Drive-iOS/
├── TelegramDrive.xcodeproj/
│   └── project.pbxproj            # Xcode Project Specification
└── TelegramDrive/
    ├── App/
    │   ├── TelegramDriveApp.swift # @main application entry point
    │   └── AppState.swift         # Reactive State, zero mock data, real file intake
    ├── Core/
    │   ├── CoreModels.swift       # Strongly-typed models (DriveFile, TransferTask, etc.)
    │   ├── TDNative.swift         # C/FFI interface to Rust MTProto core
    │   └── TDCore.swift           # High-level operations (setCredentials, auth, files, vault)
    ├── Views/
    │   ├── MainTabView.swift      # Glassmorphic bottom navigation dock
    │   ├── Auth/
    │   │   └── AuthView.swift     # 3-step setup guide, quick test credentials, OTP & QR
    │   ├── Drive/
    │   │   ├── DriveView.swift    # Folder chips, categories, empty state, grid/list, FAB
    │   │   ├── FileGridCard.swift # Grid item with badge tag and vault indicator
    │   │   ├── FileListRow.swift  # Compact row layout
    │   │   └── FileDetailSheet.swift # Download, share, TDENC2 badge, delete
    │   ├── Transfers/
    │   │   └── TransfersView.swift # Real MTProto chunk streaming queue
    │   ├── Settings/
    │   │   └── SettingsView.swift # Account, Keystore status, theme presets, clear cache
    │   └── Common/
    │       └── Theme.swift        # Obsidian Dark, Clean Light, Cyberpunk Neon, Emerald Vault
    └── Resources/
        ├── Info.plist             # iOS capabilities & permissions
        └── Assets.xcassets/       # AppIcon, AccentColor
```

## Features

- **Strictly Zero Mock Files**: Defaults to a clean empty drive state (`0 files · 0 B used`). Files intake dynamically from user storage or device picker with real sizes and types.
- **3-Step Manageable Setup Guide**: Built directly into the landing page, with one-click developer credentials preset (`2040` / `b5db36eedd9f1436e0864e9a3b1d8fad`), paste auto-detection (`ID:HASH`), 5-digit OTP auto-advance, and QR code login.
- **TDENC2 Zero-Knowledge Vault**: Transparent client-side file encryption with hardware isolation.
- **Live Chunk Streaming Queue**: Real-time progress bars, transfer rates, and auto-completion.
- **Theme Switcher**: 4 palettes (Obsidian Dark, Clean Light, Cyberpunk Neon, Emerald Vault).

## Building

Open `TelegramDrive.xcodeproj` in Xcode (15+) on macOS and select any iOS 16.0+ simulator or physical iPhone.
