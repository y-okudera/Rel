//
//  KeychainHelper.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/05.
//

import Foundation

final class KeychainHelper {

    static let shared = KeychainHelper()
    private init() {}

    func save(string: String, passwordAttr: KeychainPasswordAttribute) -> Bool {
        let data = Data(string.utf8)
        return save(data, passwordAttr: passwordAttr)
    }

    func save(_ data: Data, passwordAttr: KeychainPasswordAttribute) -> Bool {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: passwordAttr.service(),
            kSecAttrAccount: passwordAttr.account(),
        ] as CFDictionary

        let matchingStatus = SecItemCopyMatching(query, nil)
        switch matchingStatus {
        case errSecItemNotFound:
            // データが存在しない場合は保存
            let status = SecItemAdd(query, nil)
            return status == noErr
        case errSecSuccess:
            // データが存在する場合は更新
            SecItemUpdate(query, [kSecValueData as String: data] as CFDictionary)
            return true
        default:
#if DEBUG
            print("Failed to save data to keychain")
#endif
            return false
        }
    }

    func readString(passwordAttr: KeychainPasswordAttribute) -> String? {
        guard let data = read(passwordAttr: passwordAttr) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func read(passwordAttr: KeychainPasswordAttribute) -> Data? {
        let query = [
            kSecAttrService: passwordAttr.service(),
            kSecAttrAccount: passwordAttr.account(),
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)

        return result as? Data
    }

    func delete(passwordAttr: KeychainPasswordAttribute) -> Bool {
        let query = [
            kSecAttrService: passwordAttr.service(),
            kSecAttrAccount: passwordAttr.account(),
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

        let status = SecItemDelete(query)
        return status == noErr
    }
}
