//
//  IntFilter.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import Foundation

struct IntFilter {
    /// `nil`でない場合、指定文字列で始まるという条件で絞り込み
    let beginsWith: String?

    /// `nil`でない場合、指定範囲内という条件で絞り込み
    let between: (Int, Int)?

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
        beginsWith: String? = nil,
        between: (Int, Int)? = nil,
        greaterEqual: Int? = nil,
        greaterThan: Int? = nil,
        equals: Int? = nil,
        isNull: Bool? = nil,
        lessEqual: Int? = nil,
        lessThan: Int? = nil,
        notEquals: Int? = nil
    ) {
        self.beginsWith = beginsWith
        self.between = between
        self.greaterEqual = greaterEqual
        self.greaterThan = greaterThan
        self.equals = equals
        self.isNull = isNull
        self.lessEqual = lessEqual
        self.lessThan = lessThan
        self.notEquals = notEquals
    }
}
