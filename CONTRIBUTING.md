# Contributing to Atomic

First off, thank you for considering contributing to Atomic! It's people like you that make Atomic such a great tool.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
  - [Development Setup](#development-setup)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Features](#suggesting-features)
  - [Improving Documentation](#improving-documentation)
  - [Submitting Code](#submitting-code)
- [Development Workflow](#development-workflow)
  - [Branching Strategy](#branching-strategy)
  - [Commit Guidelines](#commit-guidelines)
  - [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
  - [Swift Style Guide](#swift-style-guide)
  - [Code Quality](#code-quality)
  - [Testing Requirements](#testing-requirements)
- [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to nv3212@gmail.com.

## Getting Started

### Development Setup

1. **Fork the repository**
   ```bash
   # Click the "Fork" button on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/atomic.git
   cd atomic
   ```

3. **Set up the development environment**
   ```bash
   # Bootstrap the project
   make bootstrap
   ```

4. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

5. **Open the project in Xcode**
   ```bash
   open Package.swift
   ```

## How Can I Contribute?

### Reporting Bugs

Before creating a bug report, please check the [existing issues](https://github.com/space-code/atomic/issues) to avoid duplicates.

When creating a bug report, include:

- **Clear title** - Describe the issue concisely
- **Reproduction steps** - Detailed steps to reproduce the bug
- **Expected behavior** - What you expected to happen
- **Actual behavior** - What actually happened
- **Environment** - OS, Xcode version, Swift version
- **Code samples** - Minimal reproducible example
- **Error messages** - Complete error output if applicable

**Example:**
```markdown
**Title:** Race condition in write method under high concurrency

**Steps to reproduce:**
1. Create @Atomic var counter = 0
2. Execute 10,000 concurrent writes using DispatchQueue.concurrentPerform
3. Read final value

**Expected:** Counter should equal 10,000
**Actual:** Counter shows random value less than 10,000

**Environment:**
- iOS 16.0
- Xcode 15.3
- Swift 5.10

**Code:**
\`\`\`swift
@Atomic var counter = 0
DispatchQueue.concurrentPerform(iterations: 10000) { _ in
    _counter.write { $0 += 1 }
}
print(counter) // Expected: 10000, Actual: varies
\`\`\`
```

### Suggesting Features

We love feature suggestions! When proposing a new feature, include:

- **Problem statement** - What problem does this solve?
- **Proposed solution** - How should it work?
- **Alternatives** - What alternatives did you consider?
- **Use cases** - Real-world scenarios
- **API design** - Example code showing usage
- **Breaking changes** - Will this break existing code?

**Example:**
```markdown
**Feature:** Add async/await support for Atomic operations

**Problem:** Current API is synchronous. Async operations need to await within Atomic context.

**Solution:** Add async versions of read/write methods.

**API:**
\`\`\`swift
extension Atomic {
    func read<U>(_ closure: (Value) async throws -> U) async rethrows -> U
    func write<U>(_ closure: (inout Value) async throws -> U) async rethrows -> U
}
\`\`\`

**Use case:** 
\`\`\`swift
@Atomic var cache: [String: Data] = [:]

await _cache.write { cache in
    let data = await fetchData()
    cache["key"] = data
}
\`\`\`
```

### Improving Documentation

Documentation improvements are always welcome:

- **Code comments** - Add/improve inline documentation
- **DocC documentation** - Enhance documentation articles
- **README** - Fix typos, add examples
- **Guides** - Write tutorials or how-to guides
- **API documentation** - Document public APIs

### Submitting Code

1. **Check existing work** - Look for related issues or PRs
2. **Discuss major changes** - Open an issue for large features
3. **Follow coding standards** - See [Coding Standards](#coding-standards)
4. **Write tests** - All code changes require tests
5. **Update documentation** - Keep docs in sync with code
6. **Create a pull request** - Use clear description

## Development Workflow

### Branching Strategy

We use a simplified branching model:

- **`main`** - Main development branch (all PRs target this)
- **`feature/*`** - New features
- **`fix/*`** - Bug fixes
- **`docs/*`** - Documentation updates
- **`refactor/*`** - Code refactoring
- **`test/*`** - Test improvements

**Branch naming examples:**
```bash
feature/async-support
fix/race-condition-in-write
docs/add-concurrency-guide
refactor/simplify-lock-implementation
test/add-stress-tests
```

### Commit Guidelines

We use [Conventional Commits](https://www.conventionalcommits.org/) for clear, structured commit history.

**Format:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style (formatting, no logic changes)
- `refactor` - Code refactoring
- `test` - Adding or updating tests
- `chore` - Maintenance tasks
- `perf` - Performance improvements

**Scopes:**
- `core` - Core atomic logic
- `lock` - Lock implementations
- `api` - Public API
- `tests` - Test infrastructure
- `deps` - Dependencies

**Examples:**
```bash
feat(api): add async/await support for read and write methods

Implement async versions of read() and write() to support
asynchronous operations within atomic context. Maintains
thread-safety guarantees while allowing await calls.

Closes #23

---

fix(lock): prevent deadlock in nested write operations

UnfairLock was not reentrant, causing deadlock when write()
was called from within another write(). Now uses NSRecursiveLock
for write operations to support nesting.

Fixes #45

---

docs(readme): add dynamic member lookup examples

Add examples showing how to use dynamic member lookup for
direct property access. Includes thread-safety explanation
and common pitfalls.

---

test(core): add comprehensive concurrency tests

Add tests for:
- 10,000 concurrent reads
- 10,000 concurrent writes
- Mixed read/write operations
- Nested write operations
```

**Commit message rules:**
- Use imperative mood ("add" not "added")
- Don't capitalize first letter
- No period at the end
- Keep subject line under 72 characters
- Separate subject from body with blank line
- Reference issues in footer

### Pull Request Process

1. **Update your branch**
   ```bash
   git checkout main
   git pull upstream main
   git checkout feature/your-feature
   git rebase main
   ```

2. **Run tests and checks**
   ```bash
   # Run all tests
   swift test
   
   # Check test coverage
   swift test --enable-code-coverage
   
   # Run SwiftLint (if configured)
   swiftlint
   ```

3. **Push to your fork**
   ```bash
   git push origin feature/your-feature
   ```

4. **Create pull request**
   - Target the `main` branch
   - Provide clear description
   - Link related issues
   - Include examples if applicable
   - Request review from maintainers

5. **Review process**
   - Address review comments
   - Keep PR up to date with main
   - Squash commits if requested
   - Wait for CI to pass

6. **After merge**
   ```bash
   # Clean up local branch
   git checkout main
   git pull upstream main
   git branch -d feature/your-feature
   
   # Clean up remote branch
   git push origin --delete feature/your-feature
   ```

## Coding Standards

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and [Ray Wenderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide).

**Key points:**

1. **Naming**
   ```swift
   // ✅ Good
   func read<U>(_ closure: (Value) throws -> U) rethrows -> U
   func write<U>(_ closure: (inout Value) throws -> U) rethrows -> U
   
   // ❌ Bad
   func get(_ c: (Value) throws -> Any) rethrows -> Any
   func set(_ c: (inout Value) throws -> Any) rethrows -> Any
   ```

2. **Protocols**
   ```swift
   // ✅ Good - Use "I" prefix for protocols
   protocol ILock {
       func lock()
       func unlock()
   }
   
   // ❌ Bad
   protocol Lock { }
   ```

3. **Access Control**
   ```swift
   // ✅ Good - Explicit access control
   @propertyWrapper
   public struct Atomic<Value> {
       private var value: Value
       private let lock: ILock
       
       public init(wrappedValue: Value) {
           self.value = wrappedValue
           self.lock = UnfairLock()
       }
       
       public var wrappedValue: Value {
           get { lock.around { value } }
           set { lock.around { value = newValue } }
       }
   }
   ```

4. **Documentation**
   ```swift
   /// A property wrapper that provides thread-safe access to a value.
   ///
   /// `Atomic` ensures that all reads and writes to the wrapped value are
   /// synchronized, preventing race conditions in concurrent environments.
   ///
   /// - Note: Access the wrapper using `_propertyName` to use read/write methods.
   ///
   /// - Example:
   /// ```swift
   /// @Atomic var counter = 0
   ///
   /// // Thread-safe increment
   /// _counter.write { $0 += 1 }
   ///
   /// // Thread-safe read
   /// let value = _counter.read { $0 }
   /// ```
   @propertyWrapper
   public struct Atomic<Value> {
       // Implementation
   }
   ```

### Code Quality

- **No force unwrapping** - Use optional binding or guards
- **No force casting** - Use conditional casting
- **No magic numbers** - Use named constants
- **Single responsibility** - One class, one purpose
- **DRY principle** - Don't repeat yourself
- **Thread-safety first** - All operations must be thread-safe

**Example:**
```swift
// ✅ Good
public func read<U>(_ closure: (Value) throws -> U) rethrows -> U {
    try lock.around { try closure(self.value) }
}

public func write<U>(_ closure: (inout Value) throws -> U) rethrows -> U {
    try lock.around { try closure(&self.value) }
}

// ❌ Bad
public func read<U>(_ closure: (Value) throws -> U) rethrows -> U {
    lock.lock()
    defer { lock.unlock() }  // Should use lock.around()
    return try closure(self.value)
}
```

### Testing Requirements

All code changes must include tests:

1. **Unit tests** - Test individual components
2. **Concurrency tests** - Test thread-safety with high iteration counts
3. **Edge cases** - Test boundary conditions
4. **Error handling** - Test throwing closures
5. **Performance tests** - Test lock contention

**Coverage requirements:**
- New code: minimum 80% coverage
- Modified code: maintain or improve existing coverage
- Critical paths: 100% coverage

**Test structure:**
```swift
import XCTest
@testable import Atomic

final class AtomicTests: XCTestCase, @unchecked Sendable {
    @Atomic private var counter = 0
    
    override func setUp() {
        super.setUp()
        _counter.write(0)
    }
    
    // MARK: - Basic Operations
    
    func test_thatReadReturnsCurrentValue() {
        // Given
        _counter.write(42)
        
        // When
        let result = _counter.read { $0 }
        
        // Then
        XCTAssertEqual(result, 42)
    }
    
    func test_thatWriteModifiesValue() {
        // Given
        _counter.write(0)
        
        // When
        _counter.write { $0 += 10 }
        
        // Then
        XCTAssertEqual(_counter.read { $0 }, 10)
    }
    
    // MARK: - Thread Safety
    
    func test_thatConcurrentWritesAreSafe() {
        // Given
        _counter.write(0)
        let iterations = 10_000
        
        // When
        DispatchQueue.concurrentPerform(iterations: iterations) { _ in
            _counter.write { $0 += 1 }
        }
        
        // Then
        XCTAssertEqual(_counter.read { $0 }, iterations)
    }
    
    // MARK: - Dynamic Member Lookup
    
    func test_thatDynamicMemberLookupWorks() {
        // Given
        struct Config {
            var timeout: Double = 30.0
        }
        let config = Atomic(wrappedValue: Config())
        
        // When
        config.timeout = 60.0
        
        // Then
        XCTAssertEqual(config.timeout, 60.0)
    }
    
    // MARK: - Error Handling
    
    func test_thatThrowingClosuresWork() throws {
        // Given
        enum TestError: Error { case test }
        _counter.write(10)
        
        // When/Then
        XCTAssertThrowsError(
            try _counter.write { value -> Int in
                throw TestError.test
            }
        )
        
        // Value remains unchanged
        XCTAssertEqual(_counter.read { $0 }, 10)
    }
}
```

**Concurrency test requirements:**
- Use at least 10,000 iterations for stress tests
- Test reads, writes, and mixed operations
- Verify final state matches expected result
- Test under various dispatch queue configurations

## Community

- **Discussions** - Join [GitHub Discussions](https://github.com/space-code/atomic/discussions)
- **Issues** - Track [open issues](https://github.com/space-code/atomic/issues)
- **Pull Requests** - Review [open PRs](https://github.com/space-code/atomic/pulls)

## Recognition

Contributors are recognized in:
- GitHub contributors page
- Release notes
- Project README (for significant contributions)

## Questions?

- Check [existing issues](https://github.com/space-code/atomic/issues)
- Search [discussions](https://github.com/space-code/atomic/discussions)
- Ask in [Q&A discussions](https://github.com/space-code/atomic/discussions/categories/q-a)
- Email the maintainer: nv3212@gmail.com

---

Thank you for contributing to Atomic! 🎉

Your efforts help make this project better for everyone.