//
//  DateFilter.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import Foundation

struct DateFilter: TableFilter {
    /// `nil`でない場合、指定範囲内という条件で絞り込み
    let between: (min: Date, max: Date)?

    /// `nil`でない場合、指定日時と同じか未来で絞り込み
    let greaterEqual: Date?

    /// `true`: NULLで絞り込み | `false`: NOT NULLで絞り込み | `nil`: 絞り込みなし
    let isNull: Bool?

    /// `nil`でない場合、指定日時と同じか過去で絞り込み
    let lessEqual: Date?

    init(
        between: (min: Date, max: Date)? = nil,
        greaterEqual: Date? = nil,
        isNull: Bool? = nil,
        lessEqual: Date? = nil
    ) {
        self.between = between
        self.greaterEqual = greaterEqual
        self.isNull = isNull
        self.lessEqual = lessEqual
    }

    func addPredicate(property: String, to predicate: NSPredicate) -> NSPredicate {
        var predicate = predicate
        if let between = self.between {
            predicate = predicate.and(predicate: .init(property, fromDate: between.min, toDate: between.max))
        }
        if let greaterEqual = self.greaterEqual {
            predicate = predicate.and(predicate: .init(property, fromDate: greaterEqual, toDate: nil))
        }
        if let isNull = self.isNull {
            if isNull {
                predicate = predicate.and(predicate: .init(isNil: property))
            } else {
                predicate = predicate.and(predicate: .init(isNotNil: property))
            }
        }
        if let lessEqual = self.lessEqual {
            predicate = predicate.and(predicate: .init(property, fromDate: nil, toDate: lessEqual))
        }
        return predicate
    }
}
