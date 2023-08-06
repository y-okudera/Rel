//
//  RealmAccess.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/04.
//

import Foundation
import RealmSwift

final class RealmAccess: ExceptionCatchable {
    
    typealias ErrorHandler = ((Error) -> Void)
    
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }

    /// データベースから指定されたオブジェクトタイプを取得します。
    /// - Parameters:
    ///   - objectType: 取得するオブジェクトのタイプ
    ///   - predicate: 検索条件
    /// - Returns: 取得結果
    func find<T: Object>(objectType: T.Type, predicate: NSPredicate? = nil) -> Results<T> {
        if let predicate {
            return realm.objects(objectType).filter(predicate).freeze()
        } else {
            return realm.objects(objectType).freeze()
        }
    }
    
    /// 指定されたオブジェクトをデータベースに書き込みます。
    /// クロージャパラメータとしてカスタムエラー処理が利用可能（デフォルトはreturn）
    func create<T: Object>(
        object: T,
        _ errorHandler: @escaping ErrorHandler = { _ in return }
    ) {
        do {
            try realm.write {
                try execute {
                    realm.create(T.self, value: object)
                }
            }
        }
        catch {
            errorHandler(error)
        }
    }

    /// 指定されたオブジェクトをデータベースに書き込みます。
    /// クロージャパラメータとしてカスタムエラー処理が利用可能（デフォルトはreturn）
    func create<T: Object>(
        objects: [T],
        _ errorHandler: @escaping ErrorHandler = { _ in return }
    ) {
        do {
            try realm.write {
                try execute {
                    objects.forEach {
                        realm.create(T.self, value: $0)
                    }
                }
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    /// オブジェクトがデータベースに存在する場合、指定されたオブジェクトを上書きします。存在しない場合、新しいオブジェクトとして書き込みます。
    /// クロージャパラメータとしてカスタムエラー処理が利用可能（デフォルトはreturn）
    func update<T: Object>(
        object: T,
        errorHandler: @escaping ErrorHandler = { _ in return }
    ) {
        do {
            try realm.write {
                try execute {
                    realm.add(object, update: .modified)
                }
            }
        }
        catch {
            errorHandler(error)
        }
    }

    /// オブジェクトがデータベースに存在する場合、指定されたオブジェクトを上書きします。存在しない場合、新しいオブジェクトとして書き込みます。
    /// クロージャパラメータとしてカスタムエラー処理が利用可能（デフォルトはreturn）
    func update<T: Object>(
        objects: [T],
        errorHandler: @escaping ErrorHandler = { _ in return }
    ) {
        do {
            try realm.write {
                try execute {
                    objects.forEach {
                        realm.add($0, update: .modified)
                    }
                }
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    /// オブジェクトがデータベースに存在する場合、指定されたオブジェクトを削除します。
    /// クロージャパラメータとしてカスタムエラー処理が利用可能（デフォルトはreturn）
    func delete<T: Object>(
        objectType: T.Type,
        primaryKey: Any,
        errorHandler: @escaping ErrorHandler = { _ in return }
    ) {
        guard let object = realm.object(ofType: objectType, forPrimaryKey: primaryKey) else {
            return
        }
        do {
            try realm.write {
                try execute {
                    realm.delete(object)
                }
            }
        }
        catch {
            errorHandler(error)
        }
    }

    /// オブジェクトがデータベースに存在する場合、指定されたオブジェクトを削除します。
    /// クロージャパラメータとしてカスタムエラー処理が利用可能（デフォルトはreturn）
    func delete<T: Object>(
        objects: [T],
        errorHandler: @escaping ErrorHandler = { _ in return }
    ) {
        do {
            try realm.write {
                try execute {
                    objects.forEach {
                        realm.delete($0)
                    }
                }
            }
        }
        catch {
            errorHandler(error)
        }
    }

    /// 指定タイプのすべてのデータを削除します。
    /// クロージャパラメータとしてカスタムエラー処理が利用可能（デフォルトはreturn）
    func deleteAll<T: Object>(
        objectType: T.Type,
        errorHandler: @escaping ErrorHandler = { _ in return }
    ) {
        let allObjects = realm.objects(objectType)
        do {
            try realm.write {
                try execute {
                    realm.delete(allObjects)
                }
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    /// データベースからすべての既存のデータを削除します。これには、すべてのタイプのすべてのオブジェクトが含まれます。
    /// クロージャパラメータとしてカスタムエラー処理が利用可能（デフォルトはreturn）
    ///
    /// - Warning: **Realmからすべてのオブジェクトを削除するので注意してください**
    func deleteAll(
        errorHandler: @escaping ErrorHandler = { _ in return }
    ) {
        do {
            try realm.write {
                try execute {
                    realm.deleteAll()
                }
            }
        }
        catch {
            errorHandler(error)
        }
    }
    
    /// 非同期の状況で使用する書き込みメソッド（保存、更新、削除をサポート）。書き込みロジックは "writeAction" クロージャパラメータを介して渡されます。
    /// クロージャパラメータとしてカスタムエラー処理が利用可能（デフォルトはreturn）
    func writeAsync<T: ThreadConfined>(
        _ passedObject: T,
        block: @escaping ((Realm, T?) -> Void),
        errorHandler: @escaping ErrorHandler = { _ in return }
    ) {
        realm.writeAsync(passedObject, errorHandler: errorHandler, block: block)
    }
}
