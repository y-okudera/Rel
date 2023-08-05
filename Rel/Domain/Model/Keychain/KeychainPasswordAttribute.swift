//
//  KeychainPasswordAttribute.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/05.
//

import Foundation

enum KeychainPasswordAttribute: String {
    case realmEncryptionKey

    func service() -> String {
        switch self {
        case .realmEncryptionKey:
            return "encryptionKey"
        }
    }

    func account() -> String {
        switch self {
        case .realmEncryptionKey:
            return "realm"
        }
    }

}
