//
//  Title.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/04.
//

import RealmSwift

final class Title: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var author: String
    @Persisted var genre: String
    @Persisted var publishedYear: Int
    @Persisted var volumes: Int
    @Persisted var isOpened: Bool

    convenience init(id: Int, name: String, author: String, genre: String, publishedYear: Int, volumes: Int, isOpened: Bool) {
        self.init()
        self.id = id
        self.name = name
        self.author = author
        self.genre = genre
        self.publishedYear = publishedYear
        self.volumes = volumes
        self.isOpened = isOpened
    }
}
