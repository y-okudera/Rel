//
//  IntFilter.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import Foundation

struct IntFilter: TableFilter {
    /// `nil`でない場合、指定範囲内という条件で絞り込み
    let between: (min: Int, max: Int)?

    /// `nil`でない場合、>=で絞り込み
    let greaterEqual: Int?

    /// `nil`でない場合、>で絞り込み
    let greaterThan: Int?

    /// `nil`でない場合、==で絞り込み
    let equals: Int?

    /// `true`: NULLで絞り込み | `false`: NOT NULLで絞り込み | `nil`: 絞り込みなし
    let isNull: Bool?

    /// `nil`でない場合、<=で絞り込み
    let lessEqual: Int?

    /// `nil`でない場合、<で絞り込み
    let lessThan: Int?

    /// `nil`でない場合、!=で絞り込み
    let notEquals: Int?

    init(
        between: (min: Int, max: Int)? = nil,
        greaterEqual: Int? = nil,
        greaterThan: Int? = nil,
        equals: Int? = nil,
        isNull: Bool? = nil,
        lessEqual: Int? = nil,
        lessThan: Int? = nil,
        notEquals: Int? = nil
    ) {
        self.between = between
        self.greaterEqual = greaterEqual
        self.greaterThan = greaterThan
        self.equals = equals
        self.isNull = isNull
        self.lessEqual = lessEqual
        self.lessThan = lessThan
        self.notEquals = notEquals
    }

    func addPredicate(property: String, to predicate: NSPredicate) -> NSPredicate {
        var predicate = predicate
        if let between = self.between {
            predicate = predicate.and(predicate: .init(property, between: between.min, to: between.max))
        }
        if let greaterEqual = self.greaterEqual {
            predicate = predicate.and(predicate: .init(property, equalOrGreaterThan: greaterEqual as AnyObject))
        }
        if let greaterThan = self.greaterThan {
            predicate = predicate.and(predicate: .init(property, greaterThan: greaterThan as AnyObject))
        }
        if let equals = self.equals {
            predicate = predicate.and(predicate: .init(property, equal: equals as AnyObject))
        }
        if let isNull = self.isNull {
            if isNull {
                predicate = predicate.and(predicate: .init(isNil: property))
            } else {
                predicate = predicate.and(predicate: .init(isNotNil: property))
            }
        }
        if let lessEqual = self.lessEqual {
            predicate = predicate.and(predicate: .init(property, equalOrLessThan: lessEqual as AnyObject))
        }
        if let lessThan = self.lessThan {
            predicate = predicate.and(predicate: .init(property, lessThan: lessThan as AnyObject))
        }
        if let notEquals = self.notEquals {
            predicate = predicate.not(predicate: .init(property, equal: notEquals as AnyObject))
        }
        return predicate
    }
}
