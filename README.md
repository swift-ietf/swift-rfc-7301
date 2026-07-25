# swift-rfc-7301

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The ALPN TLS extension for application-layer protocol negotiation defined in RFC 7301.

## Standard Reference

- **RFC**: 7301
- **Title**: Transport Layer Security (TLS) Application-Layer Protocol Negotiation Extension

## Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swift-ietf/swift-rfc-7301.git", from: "0.0.1")
]
```

Add the product to a target that needs it:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RFC 7301", package: "swift-rfc-7301")
    ]
)
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
