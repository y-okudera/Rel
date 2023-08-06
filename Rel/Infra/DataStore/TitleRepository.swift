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
            if let beginsWith = name.beginsWith {
                predicate = predicate.and(predicate: NSPredicate("name", beginsWith: beginsWith))
            }
            if let contains = name.contains {
                predicate = predicate.and(predicate: NSPredicate("name", contains: contains))
            }
            if let notContains = name.notContains {
                predicate = predicate.not(predicate: NSPredicate("name", contains: notContains))
            }
            if let equals = name.equals {
                predicate = predicate.and(predicate: NSPredicate("name", equal: equals as AnyObject))
            }
        }
        if let author = filter?.author {
            if let beginsWith = author.beginsWith {
                predicate = predicate.and(predicate: NSPredicate("author", beginsWith: beginsWith))
            }
            if let contains = author.contains {
                predicate = predicate.and(predicate: NSPredicate("author", contains: contains))
            }
            if let notContains = author.notContains {
                predicate = predicate.not(predicate: NSPredicate("author", contains: notContains))
            }
            if let equals = author.equals {
                predicate = predicate.and(predicate: NSPredicate("author", equal: equals as AnyObject))
            }
        }
        if let genre = filter?.genre {
            if let beginsWith = genre.beginsWith {
                predicate = predicate.and(predicate: NSPredicate("genre", beginsWith: beginsWith))
            }
            if let contains = genre.contains {
                predicate = predicate.and(predicate: NSPredicate("genre", contains: contains))
            }
            if let notContains = genre.notContains {
                predicate = predicate.not(predicate: NSPredicate("genre", contains: notContains))
            }
            if let equals = genre.equals {
                predicate = predicate.and(predicate: NSPredicate("genre", equal: equals as AnyObject))
            }
        }
        if let isOpened = filter?.isOpened {
            if let equals = isOpened.equals {
                predicate = predicate.and(predicate: NSPredicate("isOpened", equal: equals as AnyObject))
            }
        }
        print("prepre", predicate)
        let result = self.realmAccess.find(objectType: Title.self, predicate: predicate)
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
