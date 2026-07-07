// ===----------------------------------------------------------------------===//
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of project contributors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

// RFC_7301.swift
// swift-rfc-7301
//
// RFC 7301: Transport Layer Security (TLS) Application-Layer Protocol
//           Negotiation Extension (July 2014)
// https://www.rfc-editor.org/rfc/rfc7301.html
//
// This package implements ALPN as defined by RFC 7301.
// ALPN allows negotiation of the application protocol during the TLS handshake.

/// RFC 7301: TLS Application-Layer Protocol Negotiation Extension
///
/// This namespace contains types for ALPN as defined in RFC 7301 from July 2014.
///
/// ALPN allows the client and server to negotiate which application protocol
/// to use over a TLS connection.
///
/// ## Key Types
///
/// - ``Protocol``: Application protocol identifier
/// - ``Extension``: ALPN TLS extension
///
/// ## Usage
///
/// ALPN is used to negotiate protocols like HTTP/1.1, HTTP/2, or HTTP/3
/// during the TLS handshake, eliminating an extra round-trip.
///
/// ## Example
///
/// ```swift
/// // Create an ALPN extension with HTTP/2 and HTTP/1.1
/// let alpn = try RFC_7301.Extension(protocols: [.h2, .http1_1])
///
/// // Serialize for ClientHello
/// var buffer: [UInt8] = []
/// RFC_7301.Extension.serialize(alpn, into: &buffer)
/// ```
///
/// ## See Also
///
/// - [RFC 7301](https://www.rfc-editor.org/rfc/rfc7301)
/// - ``RFC_8446`` for TLS 1.3
public enum RFC_7301 {}

extension RFC_7301 {
    /// TLS extension type for ALPN
    ///
    /// Per RFC 7301 Section 3.1, ALPN uses extension type 16.
    public static let extensionType: UInt16 = 16
}
