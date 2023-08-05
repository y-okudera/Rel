//
//  KeychainAccess.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/05.
//

import Foundation

enum KeychainAccess {

    static func write(data: Data, passwordAttr: KeychainPasswordAttribute) -> Bool {
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
            print("Failed to save data to keychain")
            return false
        }
    }

    static func read(passwordAttr: KeychainPasswordAttribute) -> Data? {
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

    static func delete(passwordAttr: KeychainPasswordAttribute) -> Bool {
        let query = [
            kSecAttrService: passwordAttr.service(),
            kSecAttrAccount: passwordAttr.account(),
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

        let status = SecItemDelete(query)
        return status == noErr
    }
}

extension KeychainAccess {

    static func write(string: String, passwordAttr: KeychainPasswordAttribute) -> Bool {
        let data = Data(string.utf8)
        return write(data: data, passwordAttr: passwordAttr)
    }

    static func readStringValue(passwordAttr: KeychainPasswordAttribute) -> String? {
        guard let data = read(passwordAttr: passwordAttr) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}

extension KeychainAccess {

    static func getAllKeyChainItemsOfClass(
        _ secClass: String = kSecClassGenericPassword as String
    ) -> [(account: String, service: String, value: String)] {
        let query: [String: Any] = [
            kSecClass as String: secClass,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecReturnAttributes as String: kCFBooleanTrue!,
            kSecReturnRef as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]

        var result: AnyObject?

        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        var values = [(account: String, service: String, value: String)]()
        if lastResultCode == noErr {
            guard let array = result as? Array<Dictionary<String, Any>> else {
                return []
            }

            for item in array {
                guard let account = item[kSecAttrAccount as String] as? String,
                      let service = item[kSecAttrService as String] as? String,
                      let value = item[kSecValueData as String] as? Data else {
                    continue
                }
                if service.hasSuffix("encryptionKey") && account == "realm" {
                    values.append((account: account, service: service, value: value.map { String(format: "%.2hhx", $0) }.joined()))
                } else {
                    values.append((account: account, service: service, value: String(data: value, encoding:.utf8) ?? ""))
                }
            }
        }

        return values
    }
}
