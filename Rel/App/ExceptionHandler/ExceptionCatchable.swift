//
//  ExceptionCatchable.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/05.
//

import Foundation

protocol ExceptionCatchable {}

extension ExceptionCatchable {
    func execute(_ tryBlock: () -> ()) throws {
        try ExceptionHandler.catchException(try: tryBlock)
    }
}
