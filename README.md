<h1 align="center" style="margin-top: 0px;">atomic</h1>

<p align="center">
<a href="https://github.com/space-code/atomic/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/space-code/atomic?style=flat"></a> 
<a href="https://swiftpackageindex.com/space-code/atomic"><img alt="Swift Compability" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fspace-code%2Fatomic%2Fbadge%3Ftype%3Dswift-versions">
<a href="https://swiftpackageindex.com/space-code/atomic"><img alt="Platform Compability" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fspace-code%2Fatomic%2Fbadge%3Ftype%3Dplatforms">
<a href="https://github.com/space-code/atomic"><img alt="CI" src="https://github.com/space-code/atomic/actions/workflows/ci.yml/badge.svg?branch=main"></a>
<a href="https://codecov.io/gh/space-code/atomic"><img alt="CodeCov" src="https://codecov.io/gh/space-code/atomic/graph/badge.svg?token=XEAA2PB5PP"></a>
</p>

## Description
`atomic` is a Swift property wrapper designed to make values thread-safe.

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
    .package(url: "https://github.com/space-code/atomic.git", .upToNextMajor(from: "1.0.0"))
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