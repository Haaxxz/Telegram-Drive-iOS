import Foundation
import SwiftUI

// MARK: - File Category
public enum FileCategory: String, CaseIterable, Identifiable, Codable {
    case all = "all"
    case video = "video"
    case image = "image"
    case document = "document"
    case audio = "audio"
    case vault = "vault"
    case archive = "archive"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .all: return "All"
        case .video: return "Videos"
        case .image: return "Photos"
        case .document: return "Docs"
        case .audio: return "Audio"
        case .vault: return "Vault"
        case .archive: return "Archives"
        }
    }

    public var iconName: String {
        switch self {
        case .all: return "folder.fill"
        case .video: return "film.fill"
        case .image: return "photo.fill"
        case .document: return "doc.text.fill"
        case .audio: return "music.note"
        case .vault: return "lock.shield.fill"
        case .archive: return "archivebox.fill"
        }
    }
}

// MARK: - Drive File Model
public struct DriveFile: Identifiable, Codable, Hashable {
    public let id: String
    public var name: String
    public var rawSize: Int64
    public var date: String
    public var kind: FileCategory
    public var ext: String
    public var chat: String
    public var isVault: Bool
    public var msgId: Int64
    public var mimeType: String

    public init(
        id: String = UUID().uuidString,
        name: String,
        rawSize: Int64,
        date: String = "Today",
        kind: FileCategory = .document,
        ext: String = "",
        chat: String = "Saved Messages",
        isVault: Bool = false,
        msgId: Int64 = 0,
        mimeType: String = "application/octet-stream"
    ) {
        self.id = id
        self.name = name
        self.rawSize = rawSize
        self.date = date
        self.kind = kind
        self.ext = ext.isEmpty ? (name.components(separatedBy: ".").last?.uppercased() ?? "FILE") : ext
        self.chat = chat
        self.isVault = isVault
        self.msgId = msgId
        self.mimeType = mimeType
    }

    public var formattedSize: String {
        ByteCountFormatter.string(fromByteCount: rawSize, countStyle: .file)
    }

    public var themeColor: Color {
        if isVault { return Color(red: 0.06, green: 0.73, blue: 0.51) } // Emerald
        switch kind {
        case .video: return Color(red: 0.55, green: 0.36, blue: 0.96) // Purple
        case .image: return Color(red: 0.02, green: 0.71, blue: 0.83) // Cyan
        case .audio: return Color(red: 0.93, green: 0.28, blue: 0.60) // Pink
        case .archive: return Color(red: 0.96, green: 0.62, blue: 0.04) // Amber
        default: return Color(red: 0.23, green: 0.51, blue: 0.96) // Blue
        }
    }
}

// MARK: - Drive Folder Model
public struct DriveFolder: Identifiable, Hashable {
    public let id: String
    public var name: String
    public var isVault: Bool
    public var icon: String

    public init(id: String, name: String, isVault: Bool = false, icon: String = "folder.fill") {
        self.id = id
        self.name = name
        self.isVault = isVault
        self.icon = icon
    }
}

// MARK: - Transfer Task
public enum TransferType: String, Codable {
    case upload
    case download
}

public struct TransferTask: Identifiable, Hashable {
    public let id: String
    public var fileName: String
    public var rawSize: Int64
    public var type: TransferType
    public var progress: Double // 0.0 to 1.0
    public var status: String
    public var speed: String

    public init(
        id: String = UUID().uuidString,
        fileName: String,
        rawSize: Int64,
        type: TransferType,
        progress: Double = 0.0,
        status: String = "Starting MTProto streaming...",
        speed: String = "0 KB/s"
    ) {
        self.id = id
        self.fileName = fileName
        self.rawSize = rawSize
        self.type = type
        self.progress = progress
        self.status = status
        self.speed = speed
    }

    public var formattedSize: String {
        ByteCountFormatter.string(fromByteCount: rawSize, countStyle: .file)
    }
}

// MARK: - App Credentials
public struct AppCredentials: Codable {
    public var apiId: String
    public var apiHash: String
    public var phone: String

    public init(apiId: String = "", apiHash: String = "", phone: String = "") {
        self.apiId = apiId
        self.apiHash = apiHash
        self.phone = phone
    }

    public var isValid: Bool {
        guard let idInt = Int(apiId), idInt > 0 else { return false }
        return apiHash.count == 32 && apiHash.allSatisfy { $0.isLetter || $0.isNumber }
    }
}

// MARK: - App Theme
public enum AppTheme: String, CaseIterable, Identifiable {
    case dark = "dark"
    case light = "light"
    case cyberpunk = "cyberpunk"
    case emerald = "emerald"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .dark: return "Obsidian Dark"
        case .light: return "Clean Light"
        case .cyberpunk: return "Cyberpunk Neon"
        case .emerald: return "Emerald Vault"
        }
    }
}
