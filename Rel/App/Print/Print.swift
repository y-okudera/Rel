//
//  Print.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/05.
//

import Foundation

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
    Swift.print(items, separator: separator, terminator: terminator)
#endif
}
