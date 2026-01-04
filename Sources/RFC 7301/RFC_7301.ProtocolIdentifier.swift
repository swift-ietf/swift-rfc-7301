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

// RFC_7301.ProtocolIdentifier.swift
// swift-rfc-7301
//
// RFC 7301 Section 3.1: The Application-Layer Protocol Negotiation Extension

public import INCITS_4_1986

extension RFC_7301 {
    /// Application Protocol Identifier
    ///
    /// Protocol identifiers are opaque byte strings, typically ASCII.
    /// Well-known protocols are registered with IANA.
    ///
    /// ## Constraints
    ///
    /// Per RFC 7301:
    /// - Length: 1-255 bytes
    /// - Empty identifiers are not allowed
    ///
    /// ## Well-Known Protocols
    ///
    /// - HTTP/1.1: "http/1.1"
    /// - HTTP/2: "h2"
    /// - HTTP/2 over cleartext: "h2c"
    /// - HTTP/3: "h3"
    /// - SPDY/3.1: "spdy/3.1"
    public struct ProtocolIdentifier: Sendable, Hashable {
        /// The protocol identifier bytes
        public let rawValue: [UInt8]

        /// Creates a protocol identifier WITHOUT validation
        init(__unchecked: Void, rawValue: [UInt8]) {
            self.rawValue = rawValue
        }

        /// Creates a protocol identifier with validation
        ///
        /// - Parameter rawValue: The protocol identifier bytes (1-255 bytes)
        /// - Throws: `Error` if validation fails
        public init(rawValue: [UInt8]) throws(Error) {
            guard !rawValue.isEmpty else {
                throw Error.empty
            }
            guard rawValue.count <= 255 else {
                throw Error.tooLong(rawValue.count)
            }
            self.init(__unchecked: (), rawValue: rawValue)
        }

        /// Creates a protocol identifier from a string
        ///
        /// - Parameter string: The protocol identifier string
        /// - Throws: `Error` if validation fails
        public init(_ string: some StringProtocol) throws(Error) {
            try self.init(rawValue: Array(string.utf8))
        }
    }
}

// MARK: - Binary.Serializable

extension RFC_7301.ProtocolIdentifier: Binary.Serializable {
    /// Serializes the protocol identifier
    ///
    /// Format: length (1 byte) + identifier bytes
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ proto: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(UInt8(proto.rawValue.count))
        buffer.append(contentsOf: proto.rawValue)
    }
}

// MARK: - CustomStringConvertible

extension RFC_7301.ProtocolIdentifier: CustomStringConvertible {
    public var description: String {
        String(decoding: rawValue, as: UTF8.self)
    }
}

// MARK: - Codable

extension RFC_7301.ProtocolIdentifier: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        do {
            try self.init(string)
        } catch {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Invalid protocol identifier: \(error)"
                )
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
