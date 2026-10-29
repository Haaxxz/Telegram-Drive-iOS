import Foundation

/// High-level Swift API client for Telegram Drive Core.
/// Mirrors `com.cameronamer.telegramdrive.core.TDCore.kt` on Android.
public final class TDCore {
    public static let shared = TDCore()
    private let native = TDNative.shared

    private init() {}

    // MARK: - Credentials & Auth
    public func setCredentials(apiId: Int, apiHash: String) throws {
        let args = ["api_id": apiId, "api_hash": apiHash] as [String : Any]
        _ = try callRaw(operation: "set_credentials", args: args)
    }

    public func requestCode(phoneNumber: String) throws -> String {
        let args = ["phone_number": phoneNumber]
        return try callRaw(operation: "request_code", args: args)
    }

    public func signIn(code: String) throws -> String {
        let args = ["code": code]
        return try callRaw(operation: "sign_in", args: args)
    }

    public func checkPassword(password: String) throws -> String {
        let args = ["password": password]
        return try callRaw(operation: "check_password", args: args)
    }

    public func startQrLogin() throws -> String {
        return try callRaw(operation: "start_qr_login", args: [:])
    }

    // MARK: - Drive Operations
    public func listFiles(folderId: String, limit: Int = 50, offset: Int = 0) throws -> [DriveFile] {
        let args: [String: Any] = ["folder_id": folderId, "limit": limit, "offset": offset]
        let jsonStr = try callRaw(operation: "list_files", args: args)
        guard let data = jsonStr.data(using: .utf8),
              let list = try? JSONDecoder().decode([DriveFile].self, from: data) else {
            return []
        }
        return list
    }

    public func searchFiles(query: String) throws -> [DriveFile] {
        let args = ["query": query]
        let jsonStr = try callRaw(operation: "search_files", args: args)
        guard let data = jsonStr.data(using: .utf8),
              let list = try? JSONDecoder().decode([DriveFile].self, from: data) else {
            return []
        }
        return list
    }

    public func deleteFiles(fileIds: [String]) throws {
        let args = ["file_ids": fileIds]
        _ = try callRaw(operation: "delete_files", args: args)
    }

    public func createFolder(title: String) throws {
        let args = ["title": title]
        _ = try callRaw(operation: "create_folder", args: args)
    }

    // MARK: - Zero-Knowledge Vault (TDENC2)
    public func createVault(passphrase: String) throws {
        let args = ["passphrase": passphrase]
        _ = try callRaw(operation: "create_vault", args: args)
    }

    public func vaultStatus() throws -> Bool {
        let res = try callRaw(operation: "vault_status", args: [:])
        return res.contains("\"configured\":true")
    }

    // MARK: - Raw JSON Envelope
    private func callRaw(operation: String, args: [String: Any]) throws -> String {
        let jsonData = try JSONSerialization.data(withJSONObject: args, options: [])
        guard let jsonStr = String(data: jsonData, encoding: .utf8) else {
            throw NSError(domain: "TDCore", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON encoding error"])
        }
        let response = native.call(operation: operation, argumentsJson: jsonStr)
        if response.contains("\"error\"") {
            throw NSError(domain: "TDCore", code: -2, userInfo: [NSLocalizedDescriptionKey: response])
        }
        return response
    }
}
