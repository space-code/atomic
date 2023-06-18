//
// Concurrency
// Copyright © 2023 Space Code. All rights reserved.
//

@testable import Atomic
import XCTest

final class AtomicTests: XCTestCase {
    // MARK: Properties

    @Atomic var dict = [Int: String]()

    // MARK: Tests

    func test_thatAtomicPropertyChangesValue() {
        DispatchQueue.concurrentPerform(iterations: 1000) { _ in
            self.dict[.random(in: 0 ... 1000)] = "test"
        }
    }
}
