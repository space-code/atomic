//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

// MARK: - UnfairLock

/// A class that uses an `os_unfair_lock` for synchronization.
final class UnfairLock {
    // MARK: Properties

    /// The underlying `os_unfair_lock` used for synchronization.
    private let unfairLock: os_unfair_lock_t

    // MARK: Initialization

    /// Initializes an UnfairLock instance.
    init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }

    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }
}

// MARK: ILock

extension UnfairLock: ILock {
    func lock() {
        os_unfair_lock_lock(unfairLock)
    }

    func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
}
