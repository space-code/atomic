<h1 align="center" style="margin-top: 0px;">atomic</h1>

<p align="center">
<a href="https://github.com/space-code/atomic/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/space-code/atomic?style=flat"></a> 
<a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20watchos%20%7C%20tvos-%23989898"/></a> 
<a href="https://developer.apple.com/swift"><img alt="Swift5.5" src="https://img.shields.io/badge/language-Swift5.5-orange.svg"/></a>
<a href="https://github.com/space-code/atomic"><img alt="CI" src="https://github.com/space-code/atomic/actions/workflows/ci.yml/badge.svg?branch=main"></a>
<a href="https://github.com/apple/swift-package-manager" alt="RxSwift on Swift Package Manager" title="RxSwift on Swift Package Manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
</p>

## Description
`atomic` is a fast, safe class for making values thread-safe in Swift.

- [Usage](#usage)
- [Requirements](#requirements)
- [Installation](#installation)
- [Communication](#communication)
- [Contributing](#contributing)
- [Author](#author)
- [License](#license)

## Usage

```swift
import Atomic

/// Creates an `Atomic` property.
@Atomic var value = 5
```

## Installation
### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but `atomic` does support its use on supported platforms.

Once you have your Swift package set up, adding `atomic` as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/space-code/atomic.git", .upToNextMajor(from: "0.0.1"))
]
```

## Communication
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Contributing
Bootstrapping development environment

```
make bootstrap
```

Please feel free to help out with this project! If you see something that could be made better or want a new feature, open up an issue or send a Pull Request!

## Author
Nikita Vasilev, nv3212@gmail.com

## License
atomic is available under the MIT license. See the LICENSE file for more info.