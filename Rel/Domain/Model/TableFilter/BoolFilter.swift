//
//  BoolFilter.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import Foundation

struct BoolFilter: TableFilter {
    /// `nil`でない場合、指定値と等しいという条件で絞り込み
    let equals: Bool?

    init(equals: Bool? = nil) {
        self.equals = equals
    }

    func addPredicate(property: String, to predicate: NSPredicate) -> NSPredicate {
        var predicate = predicate
        if let equals = self.equals {
            predicate = predicate.and(predicate: .init(property, equal: equals as AnyObject))
        }
        return predicate
    }
}
