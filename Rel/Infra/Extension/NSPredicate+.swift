//
//  NSPredicate+.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import Foundation

extension NSPredicate {

    convenience init(isNil property: String) {
        self.init(format: "\(property) = nil")
    }

    convenience init(isNotNil property: String) {
        self.init(format: "\(property) != nil")
    }

    convenience init(_ property: String, equal value: AnyObject) {
        self.init(format: "\(property) = %@", argumentArray: [value])
    }

    convenience init(_ property: String, notEqual value: AnyObject) {
        self.init(format: "\(property) != %@", argumentArray: [value])
    }

    convenience init(_ property: String, equalOrGreaterThan value: AnyObject) {
        self.init(format: "\(property) >= %@", argumentArray: [value])
    }

    convenience init(_ property: String, greaterThan value: AnyObject) {
        self.init(format: "\(property) > %@", argumentArray: [value])
    }

    convenience init(_ property: String, equalOrLessThan value: AnyObject) {
        self.init(format: "\(property) <= %@", argumentArray: [value])
    }

    convenience init(_ property: String, lessThan value: AnyObject) {
        self.init(format: "\(property) < %@", argumentArray: [value])
    }
}

extension NSPredicate {

    /// 前後方一致検索（あいまい検索）
    convenience init(_ property: String, contains q: String) {
        self.init(format: "\(property) CONTAINS '\(q)'")
    }

    /// 前方一致検索
    convenience init(_ property: String, beginsWith q: String) {
        self.init(format: "\(property) BEGINSWITH '\(q)'")
    }

    /// 後方一致検索
    convenience init(_ property: String, endsWith q: String) {
        self.init(format: "\(property) ENDSWITH '\(q)'")
    }
}

extension NSPredicate {

    /// IN句
    convenience init(_ property: String, valuesIn values: [AnyObject]) {
        self.init(format: "\(property) IN %@", argumentArray: [values])
    }

    /// BETWEEN句（Int）
    convenience init(_ property: String, between min: Int, to max: Int) {
        self.init(format: "\(property) BETWEEN {%@, %@}", argumentArray: [min, max])
    }

    /// BETWEEN句（Double）
    convenience init(_ property: String, between min: Double, to max: Double) {
        self.init(format: "\(property) BETWEEN {%@, %@}", argumentArray: [min, max])
    }
}

extension NSPredicate {

    /// DateのFromTo
    /// - Parameters:
    ///   - property: プロパティ名
    ///   - fromDate: DateのFrom「いつから」
    ///   - toDate: DateのTo「いつまで」
    convenience init(_ property: String, fromDate: Date?, toDate: Date?) {
        var format = "", args = [AnyObject]()
        if let fromDate = fromDate as? NSDate {
            format += "\(property) >= %@"
            args.append(fromDate)
        }
        if let toDate = toDate as? NSDate {
            if !format.isEmpty {
                format += " AND "
            }
            format += "\(property) <= %@"
            args.append(toDate)
        }
        if args.isEmpty {
            self.init(value: true)
        } else {
            self.init(format: format, argumentArray: args)
        }
    }
}

extension NSPredicate {

    static var empty: NSPredicate {
        return NSPredicate(value: true)
    }

    func and(predicate: NSPredicate) -> NSPredicate {
        return self.compound(predicate: predicate, type: .and)
    }

    func or(predicate: NSPredicate) -> NSPredicate {
        return self.compound(predicate: predicate, type: .or)
    }

    func not(predicate: NSPredicate) -> NSPredicate {
        return self.compound(predicate: predicate, type: .not)
    }

    private func compound(predicate: NSPredicate, type: NSCompoundPredicate.LogicalType = .and) -> NSPredicate {
        let predicates = [self, predicate]

        switch type {
        case .and:
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        case .or:
            return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        case .not:
            return self.compound(predicate: NSCompoundPredicate(notPredicateWithSubpredicate: predicate))
        @unknown default:
            fatalError("NSCompoundPredicate.LogicalType @unknown default")
        }
    }
}
