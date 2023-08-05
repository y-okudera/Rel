//
//  RealmHelper.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/04.
//

import Foundation
import RealmSwift

final class RealmHelper: ExceptionCatchable {
    
    typealias ErrorHandler = ((Error) -> Void)
    
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    /// データベースから指定されたオブジェクトタイプを取得します。
    ///
    /// - Parameter objectType: 取得するオブジェクトのタイプ
    /// - Returns: 指定されたオブジェクトタイプに対するデータベースの結果
    func fetch<T: Object>(objectType: T.Type) -> Results<T> {
        return realm.objects(objectType)
    }
    
    /// 指定されたオブジェクトをデータベースに書き込みます。
    /// クロージャパラメータとしてカスタムエラー処理が利用可能（デフォルトはreturn）
    func save<T: Object>(
        object: T,
        _ errorHandler: @escaping ErrorHandler = { _ in return }
    ) {
        do {
            try realm.write {
                try execute {
                    realm.add(object)
                }
            }
        }
        catch {
            errorHandler(error)
        }
    }

    /// 指定されたオブジェクトをデータベースに書き込みます。
    /// クロージャパラメータとしてカスタムエラー処理が利用可能（デフォルトはreturn）
    func save<T: Object>(
        objects: [T],
        _ errorHandler: @escaping ErrorHandler = { _ in return }
    ) {
        do {
            try realm.write {
                try execute {
                    objects.forEach {
                        realm.add($0)
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
        object: T,
        errorHandler: @escaping ErrorHandler = { _ in return }
    ) {
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
    
    /// データベースからすべての既存のデータを削除します。これには、すべてのタイプのすべてのオブジェクトが含まれます。
    /// クロージャパラメータとしてカスタムエラー処理が利用可能（デフォルトはreturn）
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
