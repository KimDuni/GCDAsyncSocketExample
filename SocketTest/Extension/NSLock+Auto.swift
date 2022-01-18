//
//  NSLock+Auto.swift
//  SocketTest
//
//  Created by 성준 on 2022/01/18.
//

import Foundation

extension NSLocking {
    func withCriticalSection<T>(_ closure: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try closure()
    }
}
