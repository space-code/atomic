//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

@testable import Atomic
import XCTest

// MARK: - AtomicTests

final class AtomicTests: XCTestCase {
    // MARK: Properties

    @Atomic private var dict = [Int: String]()
    private let value = Atomic(wrappedValue: 5)

    @Atomic
    private var test = 4

    // MARK: Tests

    func test_thatAtomicPropertyChangesValue() {
        DispatchQueue.concurrentPerform(iterations: .iterations) { _ in
            self.dict[.random(in: 0 ... 1000)] = "test"
        }
    }

    func test_thatAtomicPropertyReadValue() {
        // given
        let initialValue = value.read { $0 }

        // when
        DispatchQueue.concurrentPerform(iterations: .iterations) { i in
            _ = value.read { $0 }
            value.write(i)
        }

        // then
        XCTAssertNotEqual(value.read { $0 }, initialValue)
    }

    func test_thatAtomicPropertyAreSetSafely() {
        // given
        struct Mutable { var value = 1 }
        let mutable = Atomic<Mutable>(wrappedValue: .init())

        // when
        DispatchQueue.concurrentPerform(iterations: .iterations) { i in
            mutable.value = i
        }

        // then
        XCTAssertNotEqual(mutable.value, 1)
    }

    func test_thatAtomicPropertyEqual() {
        // given
        let value1 = Atomic(wrappedValue: 1)
        let value2 = Atomic(wrappedValue: 1)

        // then
        XCTAssertEqual(value1, value2)
    }

    func test_thatAtomicPropertyConfrmancesToHashable() {
        // given
        struct Mutable: Hashable { var value = 1 }
        let mutable1 = Atomic<Mutable>(wrappedValue: .init())
        let mutable2 = Atomic<Mutable>(wrappedValue: .init())

        // then
        XCTAssertEqual(mutable1.hashValue, mutable2.hashValue)
    }
}

// MARK: Constants

private extension Int {
    static let iterations = 10000
}
