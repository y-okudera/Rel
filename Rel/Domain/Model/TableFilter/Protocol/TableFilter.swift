//
//  TableFilter.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/08.
//

import Foundation

protocol TableFilter {
    func addPredicate(property: String, to predicate: NSPredicate) -> NSPredicate
}
