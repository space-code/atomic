<h1 align="center" style="margin-top: 0px;">atomic</h1>

<p align="center">
<a href="https://github.com/space-code/atomic/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/space-code/atomic?style=flat"></a> 
<a href="https://swiftpackageindex.com/space-code/atomic"><img alt="Swift Compatibility" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fspace-code%2Fatomic%2Fbadge%3Ftype%3Dswift-versions"></a>
<a href="https://swiftpackageindex.com/space-code/atomic"><img alt="Platform Compatibility" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fspace-code%2Fatomic%2Fbadge%3Ftype%3Dplatforms"></a> 
<a href="https://github.com/space-code/atomic/actions/workflows/ci.yml"><img alt="CI" src="https://github.com/space-code/atomic/actions/workflows/ci.yml/badge.svg?branch=main"></a>
<a href="https://github.com/apple/swift-package-manager" alt="atomic on Swift Package Manager" title="atomic on Swift Package Manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
<a href="https://codecov.io/gh/space-code/atomic"><img src="https://codecov.io/gh/space-code/atomic/graph/badge.svg?token=XEAA2PB5PP"/></a>
</p>

## Description
Atomic is a lightweight Swift property wrapper that provides thread-safe access to values. It ensures safe concurrent access to properties without the complexity of manual lock management.

## Features

🔒 **Thread-Safe** - Automatic synchronization for concurrent access  
⚡ **Simple API** - Just add `@Atomic` to any property  
🎯 **Type-Safe** - Works with any Swift type  
📱 **Cross-Platform** - Works on iOS, macOS, tvOS, watchOS, and visionOS  
⚡ **Lightweight** - Minimal footprint with zero dependencies  
🧪 **Well Tested** - Comprehensive test coverage

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [Communication](#communication)
- [Contributing](#contributing)
- [Author](#author)
- [License](#license)

## Requirements

| Platform  | Minimum Version |
|-----------|----------------|
| iOS       | 13.0+          |
| macOS     | 10.15+         |
| tvOS      | 13.0+          |
| watchOS   | 6.0+           |
| visionOS  | 1.0+           |
| Xcode     | 15.3+          |
| Swift     | 5.10+           |

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/space-code/atomic.git", from: "1.0.0")
]
```

Or add it through Xcode:

1. File > Add Package Dependencies
2. Enter package URL: `https://github.com/space-code/atomic.git`
3. Select version requirements

## Quick Start

```swift
import Atomic

@Atomic var counter = 0

// Thread-safe increment from multiple threads
DispatchQueue.concurrentPerform(iterations: 1000) { _ in
    counter += 1
}

print("Final count: \(counter)") // Always 1000
```

## Usage

### Basic Usage

Simply add the `@Atomic` property wrapper to any property that needs thread-safe access:

```swift
import Atomic

class UserSession {
    @Atomic var user: User?
    @Atomic var loginAttempts = 0
    
    func login(username: String, password: String) async throws {
        // Thread-safe write
        _loginAttempts.write { $0 += 1 }
        
        // Perform authentication
        let authenticatedUser = try await authenticate(username, password)
        
        // Thread-safe write with new value
        _user.write(authenticatedUser)
    }
    
    func getCurrentUsername() -> String? {
        // Thread-safe read
        _user.read { $0?.username }
    }
}
```

### Thread-Safe Collections

```swift
import Atomic

class DataCache {
    @Atomic private var cache: [String: Data] = [:]
    
    func store(_ data: Data, forKey key: String) {
        _cache.write { cache in
            cache[key] = data
        }
    }
    
    func retrieve(forKey key: String) -> Data? {
        _cache.read { $0[key] }
    }
    
    func removeExpired(before date: Date) {
        _cache.write { cache in
            cache = cache.filter { $0.value.timestamp > date }
        }
    }
}
```

## Communication

- 🐛 **Found a bug?** [Open an issue](https://github.com/space-code/atomic/issues/new)
- 💡 **Have a feature request?** [Open an issue](https://github.com/space-code/atomic/issues/new)
- ❓ **Questions?** [Start a discussion](https://github.com/space-code/atomic/discussions)
- 🔒 **Security issue?** Email nv3212@gmail.com

## Contributing

We love contributions! Please feel free to help out with this project. If you see something that could be made better or want a new feature, open up an issue or send a Pull Request.

### Development Setup

Bootstrap the development environment:

```bash
make bootstrap
```

## Author

**Nikita Vasilev**
- Email: nv3212@gmail.com
- GitHub: [@ns-vasilev](https://github.com/ns-vasilev)

## License

Atomic is released under the MIT license. See [LICENSE](https://github.com/space-code/atomic/blob/main/LICENSE) for details.

---

<div align="center">

**[⬆ back to top](#atomic)**

Made with ❤️ by [space-code](https://github.com/space-code)

</div>
