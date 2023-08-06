//
//  BoolFilter.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import Foundation

struct BoolFilter {
    /// `nil`でない場合、指定値と等しいという条件で絞り込み
    let equals: Bool?

    init(equals: Bool? = nil) {
        self.equals = equals
    }
}
