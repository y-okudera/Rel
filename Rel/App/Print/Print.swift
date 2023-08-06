//
//  Print.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/05.
//

import Foundation

func print(_ items: Any...) {
#if DEBUG
    Swift.print(items, separator: " ", terminator: "\n")
#endif
}

func dump<T>(_ value: T, name: String? = nil) {
#if DEBUG
    _ = Swift.dump(value, name: name)
#endif
}
