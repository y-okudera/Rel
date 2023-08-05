//
//  Title.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/04.
//

import RealmSwift

final class Title: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var name = ""
    @Persisted var isOpened = false

    convenience init(id: Int, name: String, isOpened: Bool) {
        self.init()
        self.id = id
        self.name = name
        self.isOpened = isOpened
    }
}
