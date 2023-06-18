//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

/// An `Atomic` property wrapper.
@propertyWrapper
public final class Atomic<Value> {
    // MARK: Properties

    private let semaphore = DispatchSemaphore(value: 1)
    private var value: Value

    // MARK: Initialization

    /// Create a new `Atomic` property wrapper with the given value.
    ///
    /// - Parameter value: A value object,
    public init(wrappedValue value: Value) {
        self.value = value
    }

    // MARK: Public

    /// Automatically gets or sets the value of the variable.
    public var wrappedValue: Value {
        get {
            semaphore.wait()
            defer { semaphore.signal() }
            return value
        }
        set {
            semaphore.wait()
            value = newValue
            semaphore.signal()
        }
    }
}
