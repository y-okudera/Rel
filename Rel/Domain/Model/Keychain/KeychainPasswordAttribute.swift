//
//  KeychainPasswordAttribute.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/05.
//

import Foundation

enum KeychainPasswordAttribute {
    case realmEncryptionKey

    func service() -> String {
        let service = {
            switch self {
            case .realmEncryptionKey:
                return "encryptionKey"
            }
        }()
        return Environment.keychainPrefix + service
    }

    func account() -> String {
        switch self {
        case .realmEncryptionKey:
            return "realm"
        }
    }

}
