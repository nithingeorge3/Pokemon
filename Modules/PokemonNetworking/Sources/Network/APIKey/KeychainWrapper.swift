import Foundation
import Security

//this keychain wrapper class I have refered from net
final class KeychainWrapper {
    
    /// Stores (or updates) a String value in the keychain for a given key.
    ///
    /// - Parameters:
    ///   - value: The string you want to store (e.g., an API key).
    ///   - account: The key or "account" under which to store it.
    /// - Returns: `true` if storing succeeded; otherwise `false`.
    @discardableResult
    func save(value: String, for account: String) -> Bool {
        guard let encodedValue = value.data(using: .utf8) else {
            return false
        }
        
        // A dictionary of keychain attributes/values to store.
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrAccount as String:      account,
            kSecValueData as String:        encodedValue
        ]
        
        // Delete any existing item before adding (to handle "update" case).
        SecItemDelete(query as CFDictionary)
        
        // Add new item to keychain.
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Retrieves a String value from the keychain for a given key.
    ///
    /// - Parameter account: The key or "account" under which the value is stored.
    /// - Returns: The stored string if it exists, or `nil` if not found.
    func retrieveValue(for account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String:            kSecClassGenericPassword,
            kSecAttrAccount as String:      account,
            // We want the data back if it exists:
            kSecReturnData as String:       kCFBooleanTrue as Any,
            // Limit to one search result:
            kSecMatchLimit as String:       kSecMatchLimitOne
        ]
        
        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &itemCopy)
        
        // Check if we found something.
        guard status == errSecSuccess,
              let retrievedData = itemCopy as? Data,
              let value = String(data: retrievedData, encoding: .utf8)
        else {
            return nil
        }
        
        return value
    }
    
    /// Deletes a stored value in the keychain for a given key.
    ///
    /// - Parameter account: The key or "account" under which the value is stored.
    /// - Returns: `true` if deleting succeeded or item not found; otherwise `false`.
    @discardableResult
    func deleteValue(for account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return (status == errSecSuccess || status == errSecItemNotFound)
    }
}
