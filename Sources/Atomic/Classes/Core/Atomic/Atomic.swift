//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

import Foundation

// MARK: - Atomic

/// An `Atomic` property wrapper.
@propertyWrapper
@dynamicMemberLookup
public final class Atomic<Value>: @unchecked Sendable {
    // MARK: Properties

    private let lock = UnfairLock()
    private var value: Value

    /// Automatically gets or sets the value of the variable.
    public var wrappedValue: Value {
        get { lock.around { value } }
        set { lock.around { value = newValue } }
    }

    // MARK: Initialization

    /// Create a new `Atomic` property wrapper with the given value.
    ///
    /// - Parameter value: A value object,
    public init(wrappedValue value: Value) {
        self.value = value
    }

    // MARK: Public

    /// Reads the current value of the resource and executes a closure with it, ensuring exclusive access.
    ///
    /// - Parameter closure: A closure that takes the current value and returns a result.
    ///
    /// - Returns: The result returned by the closure.
    public func read<U>(_ closure: (Value) throws -> U) rethrows -> U {
        try lock.around { try closure(self.value) }
    }

    /// Modifies the resource's value using a closure and ensures exclusive access while doing so.
    ///
    /// - Parameter closure: A closure that takes an inout reference to the current value and returns a result.
    ///
    /// - Returns: The result returned by the closure.
    public func write<U>(_ closure: (inout Value) throws -> U) rethrows -> U {
        try lock.around { try closure(&self.value) }
    }

    /// Writes a new value to the resource while ensuring exclusive access.
    ///
    /// - Parameter value: The new value to set.
    public func write(_ value: Value) {
        write { $0 = value }
    }

    subscript<Property>(dynamicMember keyPath: WritableKeyPath<Value, Property>) -> Property {
        get { lock.around { value[keyPath: keyPath] } }
        set { lock.around { value[keyPath: keyPath] = newValue } }
    }
}

// MARK: Equatable

extension Atomic: Equatable where Value: Equatable {
    public static func == (lhs: Atomic<Value>, rhs: Atomic<Value>) -> Bool {
        lhs.read { left in rhs.read { right in left == right } }
    }
}

// MARK: Hashable

extension Atomic: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        read { hasher.combine($0) }
    }
}
