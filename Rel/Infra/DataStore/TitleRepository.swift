//
//  TitleRepository.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import Foundation
import RealmSwift

enum TitleRepositoryProvider {
    static func provide() -> TitleRepository {
        TitleDataStore(realmAccess: .init(realm: .encrypted))
    }
}

protocol TitleRepository {
    init(realmAccess: RealmAccess)
    func createOne(title: Title)
    func createList(titles: [Title])
    func findOne(filter: TitleFilterInput?) -> Title?
    func findList(filter: TitleFilterInput?) -> [Title]
    func updateOne(title: Title)
    func updateList(titles: [Title])
    func deleteAllTitles()
}

struct TitleDataStore: TitleRepository {

    private let realmAccess: RealmAccess

    init(realmAccess: RealmAccess) {
        self.realmAccess = realmAccess
    }

    func createOne(title: Title) {
        self.realmAccess.create(object: title)
    }

    func createList(titles: [Title]) {
        self.realmAccess.create(objects: titles)
    }

    func findOne(filter: TitleFilterInput?) -> Title? {
        var predicate = NSPredicate.empty
        if let id = filter?.id {
            if let equals = id.equals {
                predicate = predicate.and(predicate: NSPredicate("id", equal: equals as AnyObject))
            }
        }

        if let result = self.realmAccess.find(objectType: Title.self, predicate: predicate).first {
            return Title(value: result)
        } else {
            return nil
        }
    }

    func findList(filter: TitleFilterInput?) -> [Title] {
        var predicate = NSPredicate.empty
        if let name = filter?.name {
            predicate = name.addPredicate(property: "name", to: predicate)
        }
        if let author = filter?.author {
            predicate = author.addPredicate(property: "author", to: predicate)
        }
        if let genre = filter?.genre {
            predicate = genre.addPredicate(property: "genre", to: predicate)
        }
        if let publishedYear = filter?.publishedYear {
            predicate = publishedYear.addPredicate(property: "publishedYear", to: predicate)
        }
        if let isOpened = filter?.isOpened {
            predicate = isOpened.addPredicate(property: "isOpened", to: predicate)
        }
        if let createdAt = filter?.createdAt {
            predicate = createdAt.addPredicate(property: "createdAt", to: predicate)
        }
        if let updatedAt = filter?.updatedAt {
            predicate = updatedAt.addPredicate(property: "updatedAt", to: predicate)
        }
        print("predicate", predicate)
        let result = self.realmAccess.find(objectType: Title.self, predicate: predicate)
        print("result", result.count)
        return Array(result)
    }

    func updateOne(title: Title) {
        self.realmAccess.update(object: title)
    }

    func updateList(titles: [Title]) {
        self.realmAccess.update(objects: titles)
    }

    func deleteAllTitles() {
        self.realmAccess.deleteAll(objectType: Title.self)
    }
}
