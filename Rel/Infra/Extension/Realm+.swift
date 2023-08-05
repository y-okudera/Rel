//
//  Realm+.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/05.
//

import RealmSwift

extension Realm {

    static let inMemory: Self = {
        let config = Realm.Configuration(inMemoryIdentifier: "inMemory")
        do {
            let realm = try Realm(configuration: config)
            return realm
        }
        catch {
            fatalError("InMemory Realm initialize error: \(error)")
        }
    }()
    
    static let encrypted: Self = {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let realmFileUrl = documentDirectory?.appendingPathComponent("encrypted.realm")
        print("realmFileUrl -> \(realmFileUrl?.absoluteString ?? "")")
        let config = Realm.Configuration(fileURL: realmFileUrl, encryptionKey: realmEncryptionKey)
        do {
            let realm = try Realm(configuration: config)
            return realm
        }
        catch {
            fatalError("Encrypted Realm initialize error: \(error)")
        }
    }()
    
    private static let realmEncryptionKey: Data = {
        if let encryptionKey = KeychainAccess.read(passwordAttr: .realmEncryptionKey) {
            print("キーチェーンから取得")
            print("Realm encryptionKey -> " + encryptionKey.map { String(format: "%.2hhx", $0) }.joined())
            return encryptionKey
        } else {
            
            let encryptionKey: Data = {
                var key = Data(count: 64)
                _ = key.withUnsafeMutableBytes { mutableRawBufferPointer -> Int32 in
                    let bufferPointer = mutableRawBufferPointer.bindMemory(to: UInt8.self)
                    if let address = bufferPointer.baseAddress{
                        return SecRandomCopyBytes(kSecRandomDefault, 64, address)
                    }
                    return 0
                }
                return key
            }()
            let result = KeychainAccess.write(data: encryptionKey, passwordAttr: .realmEncryptionKey)
            print("キーチェーン保存: \(result ? "成功" : "失敗")")
            print("Realm encryptionKey -> " + encryptionKey.map { String(format: "%.2hhx", $0) }.joined())
            return encryptionKey
        }
    }()
}

extension Realm {

    func writeAsync<T: ThreadConfined>(
        _ passedObject: T,
        errorHandler: @escaping ((_ error: Swift.Error) -> Void) = { _ in return },
        block: @escaping ((Realm, T?) -> Void)
    ) {
        let objectReference = ThreadSafeReference(to: passedObject)
        let configuration = self.configuration

        let label = Bundle.main.bundleIdentifier == nil ? "background" : Bundle.main.bundleIdentifier! + ".realm"
        DispatchQueue(label: label, autoreleaseFrequency: .workItem).async {
            do {
                let realm = try Realm(configuration: configuration)
                try realm.write {
                    // Resolve within the transaction to ensure you get the latest changes from other threads
                    let object = realm.resolve(objectReference)
                    block(realm, object)
                }
            } catch {
                errorHandler(error)
            }
        }
    }
}
