//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

@testable import Atomic
import XCTest

// MARK: - AtomicTests

final class AtomicTests: XCTestCase, @unchecked Sendable {
    // MARK: Properties

    @Atomic private var dict = [Int: String]()
    @Atomic private var counter = 0
    @Atomic private var test = 4

    private let value = Atomic(wrappedValue: 5)

    // MARK: Setup

    override func setUp() {
        super.setUp()
        _dict.write([:])
        _counter.write(0)
        _test.write(4)
    }

    // MARK: Tests - Basic Operations

    func test_thatDictionaryChangesValue_whenConcurrentWritesOccur() {
        DispatchQueue.concurrentPerform(iterations: .iterations) { _ in
            _dict.write { dict in
                dict[.random(in: 0 ... 1000)] = "test"
            }
        }

        let finalCount = _dict.read { $0.count }
        XCTAssertGreaterThan(finalCount, 0)
    }

    func test_thatValueChanges_whenConcurrentReadsAndWritesOccur() {
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

    func test_thatValueIsSet_whenConcurrentWritesOccur() {
        // given
        struct Mutable { var value = 1 }
        let mutable = Atomic<Mutable>(wrappedValue: .init())

        // when
        DispatchQueue.concurrentPerform(iterations: .iterations) { i in
            mutable.write(Mutable(value: i))
        }

        // then
        XCTAssertNotEqual(mutable.read { $0.value }, 1)
    }

    // MARK: Tests - Read/Write Methods

    func test_thatReadReturnsCurrentValue_whenValueIsSet() {
        // given
        _counter.write(42)

        // when
        let result = _counter.read { $0 }

        // then
        XCTAssertEqual(result, 42)
    }

    func test_thatValueIsModified_whenWriteClosureExecutes() {
        // given
        _counter.write(0)

        // when
        _counter.write { value in
            value += 10
        }

        // then
        let result = _counter.read { $0 }
        XCTAssertEqual(result, 10)
    }

    func test_thatValueIsSet_whenWriteValueCalled() {
        // given
        _counter.write(0)

        // when
        _counter.write(100)

        // then
        let result = _counter.read { $0 }
        XCTAssertEqual(result, 100)
    }

    func test_thatClosureResultReturned_whenWriteExecutes() {
        // given
        _counter.write(5)

        // when
        let result = _counter.write { value -> String in
            value *= 2
            return "Result: \(value)"
        }

        // then
        XCTAssertEqual(result, "Result: 10")
        XCTAssertEqual(_counter.read { $0 }, 10)
    }

    // MARK: Tests - Thread Safety

    func test_thatAllReadsReturnSameValue_whenConcurrentReadsOccur() {
        // given
        _counter.write(100)
        let results = Box<[Int]>([])

        // when
        DispatchQueue.concurrentPerform(iterations: .iterations) { _ in
            let value = _counter.read { $0 }
            results.mutate { $0.append(value) }
        }

        // then
        XCTAssertEqual(results.value.count, .iterations)
        XCTAssertTrue(results.value.allSatisfy { $0 == 100 })
    }

    func test_thatFinalValueIsCorrect_whenConcurrentWritesOccur() {
        // given
        _counter.write(0)

        // when
        DispatchQueue.concurrentPerform(iterations: .iterations) { _ in
            _counter.write { $0 += 1 }
        }

        // then
        let finalValue = _counter.read { $0 }
        XCTAssertEqual(finalValue, .iterations)
    }

    func test_thatOperationsAreSafe_whenMixedReadWritesOccur() {
        // given
        _counter.write(0)
        let readValues = Box<[Int]>([])

        // when
        DispatchQueue.concurrentPerform(iterations: .iterations) { i in
            if i % 2 == 0 {
                _counter.write { $0 += 1 }
            } else {
                let value = _counter.read { $0 }
                readValues.mutate { $0.append(value) }
            }
        }

        // then
        let finalValue = _counter.read { $0 }
        XCTAssertEqual(finalValue, .iterations / 2)
        XCTAssertEqual(readValues.value.count, .iterations / 2)
    }

    // MARK: Tests - Dynamic Member Lookup

    func test_thatPropertyValuesReturned_whenDynamicMemberLookupGets() {
        // given
        struct Config {
            var timeout: Double = 30.0
            var retryCount: Int = 3
        }
        let config = Atomic(wrappedValue: Config())

        // when
        let timeout = config.timeout
        let retryCount = config.retryCount

        // then
        XCTAssertEqual(timeout, 30.0)
        XCTAssertEqual(retryCount, 3)
    }

    func test_thatPropertyValuesSet_whenDynamicMemberLookupSets() {
        // given
        struct Config {
            var timeout: Double = 30.0
            var retryCount: Int = 3
        }
        let config = Atomic(wrappedValue: Config())

        // when
        config.timeout = 60.0
        config.retryCount = 5

        // then
        XCTAssertEqual(config.timeout, 60.0)
        XCTAssertEqual(config.retryCount, 5)
    }

    func test_thatOperationsAreSafe_whenDynamicMemberLookupUsedConcurrently() {
        // given
        struct Counter {
            var value: Int = 0
        }
        let atomicCounter = Atomic(wrappedValue: Counter())

        // when
        DispatchQueue.concurrentPerform(iterations: .iterations) { _ in
            atomicCounter.write { $0.value += 1 }
        }

        // then
        XCTAssertEqual(atomicCounter.value, .iterations)
    }

    // MARK: Tests - Collections

    func test_thatAllValuesStored_whenDictionaryWrittenConcurrently() {
        // given
        _dict.write([:])

        // when
        DispatchQueue.concurrentPerform(iterations: .iterations) { i in
            _dict.write { dict in
                dict[i] = "value_\(i)"
            }
        }

        // then
        let finalCount = _dict.read { $0.count }
        XCTAssertEqual(finalCount, .iterations)
    }

    func test_thatAllItemsAppended_whenArrayWrittenConcurrently() {
        // given
        @Atomic var array: [Int] = []
        let atomicArray = _array

        // when
        DispatchQueue.concurrentPerform(iterations: .iterations) { i in
            atomicArray.write { arr in
                arr.append(i)
            }
        }

        // then
        let finalCount = _array.read { $0.count }
        XCTAssertEqual(finalCount, .iterations)
    }

    // MARK: Tests - Equatable & Hashable

    func test_thatValuesAreEqual_whenWrappedValuesMatch() {
        // given
        let value1 = Atomic(wrappedValue: 1)
        let value2 = Atomic(wrappedValue: 1)

        // then
        XCTAssertEqual(value1, value2)
    }

    func test_thatValuesAreNotEqual_whenWrappedValuesDiffer() {
        // given
        let value1 = Atomic(wrappedValue: 1)
        let value2 = Atomic(wrappedValue: 2)

        // then
        XCTAssertNotEqual(value1, value2)
    }

    func test_thatHashValuesMatch_whenWrappedValuesAreEqual() {
        // given
        struct Mutable: Hashable { var value = 1 }
        let mutable1 = Atomic<Mutable>(wrappedValue: .init())
        let mutable2 = Atomic<Mutable>(wrappedValue: .init())

        // then
        XCTAssertEqual(mutable1.hashValue, mutable2.hashValue)
    }

    // MARK: Tests - Complex Scenarios

    func test_thatNestedModificationsWork_whenWriteClosureExecutes() {
        // given
        struct Data {
            var items: [String] = []
            var count: Int = 0
        }
        let data = Atomic(wrappedValue: Data())

        // when
        data.write { value in
            value.items.append("item1")
            value.count = value.items.count

            value.items.append("item2")
            value.count = value.items.count
        }

        // then
        let result = data.read { ($0.items.count, $0.count) }
        XCTAssertEqual(result.0, 2)
        XCTAssertEqual(result.1, 2)
    }

    func test_thatValueRemainsUnchanged_whenThrowingClosureThrows() {
        // given
        enum TestError: Error {
            case testError
        }
        _counter.write(10)

        // when/then
        XCTAssertThrowsError(try _counter.write { value -> Int in
            if value > 5 {
                throw TestError.testError
            }
            return value
        })

        // Verify value wasn't modified
        XCTAssertEqual(_counter.read { $0 }, 10)
    }

    func test_thatTransformedValueReturned_whenReadThrowingClosureSucceeds() throws {
        // given
        enum TestError: Error {
            case testError
        }
        _counter.write(10)

        // when
        let result = try _counter.read { value -> Int in
            guard value > 0 else {
                throw TestError.testError
            }
            return value * 2
        }

        // then
        XCTAssertEqual(result, 20)
    }
}

// MARK: AtomicTests.Box

extension AtomicTests {
    private class Box<T>: @unchecked Sendable {
        private let lock = NSLock()
        private var _value: T

        init(_ value: T) {
            _value = value
        }

        var value: T {
            lock.lock(); defer { lock.unlock() }
            return _value
        }

        func mutate(_ block: (inout T) -> Void) {
            lock.lock(); defer { lock.unlock() }
            block(&_value)
        }
    }
}

// MARK: Constants

private extension Int {
    static let iterations = 10000
}
