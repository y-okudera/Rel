//
//  TitleFilterInput.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import Foundation

struct TitleFilterInput {
    let id: IntFilter?
    let name: StringFilter?
    let author: StringFilter?
    let genre: StringFilter?
    let publishedYear: IntFilter?
    let volumes: IntFilter?
    let isOpened: BoolFilter?
    let createdAt: DateFilter?
    let updatedAt: DateFilter?

    init(
        id: IntFilter? = nil,
        name: StringFilter? = nil,
        author: StringFilter? = nil,
        genre: StringFilter? = nil,
        publishedYear: IntFilter? = nil,
        volumes: IntFilter? = nil,
        isOpened: BoolFilter? = nil,
        createdAt: DateFilter? = nil,
        updatedAt: DateFilter? = nil
    ) {
        self.id = id
        self.name = name
        self.author = author
        self.genre = genre
        self.publishedYear = publishedYear
        self.volumes = volumes
        self.isOpened = isOpened
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
