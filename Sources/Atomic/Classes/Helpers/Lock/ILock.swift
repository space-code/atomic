//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

// MARK: - ILock

/// Protocol for locking and unlocking mechanisms.
protocol ILock {
    /// Locks a resource to prevent concurrent access.
    func lock()

    /// Unlocks a previously locked resource, allowing concurrent access.
    func unlock()
}

extension ILock {
    /// Executes a closure while holding the lock, and automatically unlocks afterward.
    ///
    /// - Parameter closure: The closure to execute.
    /// - Returns: The result returned by the closure.
    func around<T>(_ closure: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try closure()
    }

    /// Executes a closure while holding the lock, and automatically unlocks afterward.
    ///
    /// - Parameter closure: The closure to execute.
    func around(_ closure: () throws -> Void) rethrows {
        lock()
        defer { unlock() }
        try closure()
    }
}
