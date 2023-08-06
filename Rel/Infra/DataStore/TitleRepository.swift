//
//  TitleRepository.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import Foundation
import RealmSwift

struct TitleRepository {

    private let realmAccess: RealmAccess

    init(realmAccess: RealmAccess) {
        self.realmAccess = realmAccess
    }

    func create(title: Title) {
        self.realmAccess.save(object: title)
    }

    func create(titles: [Title]) {
        self.realmAccess.save(objects: titles)
    }

    func find(filter: TitleFilterInput?) -> [Title] {
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
        print("prepre", predicate)
        let result = self.realmAccess.find(objectType: Title.self, predicate: predicate)
        print("result", result.count)
        return Array(result)
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

    func update(title: Title) {
        self.realmAccess.update(object: title)
    }

    func update(titles: [Title]) {
        self.realmAccess.update(objects: titles)
    }

    func deleteAllTitles() {
        self.realmAccess.deleteAll(objectType: Title.self)
    }
}
