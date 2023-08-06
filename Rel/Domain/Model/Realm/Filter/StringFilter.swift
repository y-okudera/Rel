//
//  StringFilter.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import Foundation

struct StringFilter {
    /// `nil`でない場合、指定文字列で始まるという条件で絞り込み
    let beginsWith: String?

    /// `nil`でない場合、指定文字列を含むという条件で絞り込み
    let contains: String?

    /// `nil`でない場合、指定文字列と等しいという条件で絞り込み
    let equals: String?

    /// `true`: NULLで絞り込み | `false`: NOT NULLで絞り込み | `nil`: 絞り込みなし
    let isNull: Bool?

    /// `nil`でない場合、指定文字列と等しくないという条件で絞り込み
    let notEquals: String?

    /// `nil`でない場合、指定文字列を含まないという条件で絞り込み
    let notContains: String?

    init(
        beginsWith: String? = nil,
        contains: String? = nil,
        equals: String? = nil,
        isNull: Bool? = nil,
        notEquals: String? = nil,
        notContains: String? = nil
    ) {
        self.beginsWith = beginsWith
        self.contains = contains
        self.equals = equals
        self.isNull = isNull
        self.notEquals = notEquals
        self.notContains = notContains
    }
}
