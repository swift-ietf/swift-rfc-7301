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

// RFC_7301.Extension.swift
// swift-rfc-7301
//
// RFC 7301 Section 3.1: The Application-Layer Protocol Negotiation Extension

extension RFC_7301 {
    /// ALPN TLS Extension
    ///
    /// Carries the list of protocols the client supports (in ClientHello)
    /// or the selected protocol (in ServerHello/EncryptedExtensions).
    ///
    /// ## Wire Format (ClientHello)
    ///
    /// ```
    /// struct {
    ///     opaque ProtocolName<1..2^8-1>;
    /// } ProtocolName;
    ///
    /// struct {
    ///     ProtocolName protocol_name_list<2..2^16-1>
    /// } ProtocolNameList;
    /// ```
    ///
    /// ## Wire Format (ServerHello)
    ///
    /// Contains exactly one protocol (the selected one).
    public struct Extension: Sendable, Hashable {
        /// List of supported protocols (in preference order)
        public let protocols: [ProtocolIdentifier]

        /// Creates an ALPN extension
        ///
        /// - Parameter protocols: List of protocols in preference order
        /// - Throws: `Error.noProtocols` if list is empty
        public init(protocols: [ProtocolIdentifier]) throws(Error) {
            guard !protocols.isEmpty else {
                throw Error.noProtocols
            }
            self.protocols = protocols
        }

        /// Creates an ALPN extension with a single protocol (for server response)
        ///
        /// - Parameter selected: The selected protocol
        public init(selected: ProtocolIdentifier) {
            self.protocols = [selected]
        }

        /// The selected protocol (first in list)
        ///
        /// In a server response, this is the negotiated protocol.
        public var selected: ProtocolIdentifier? {
            protocols.first
        }
    }
}

// MARK: - Error

extension RFC_7301.Extension {
    /// Errors that can occur when creating ALPN extensions
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Protocol list cannot be empty
        case noProtocols
    }
}

extension RFC_7301.Extension.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .noProtocols:
            return "ALPN extension requires at least one protocol"
        }
    }
}

// MARK: - Binary.Serializable

extension RFC_7301.Extension: Binary.Serializable {
    /// Serializes the ALPN extension
    ///
    /// Format:
    /// - Extension type (2 bytes): 16
    /// - Extension length (2 bytes)
    /// - Protocol list length (2 bytes)
    /// - Protocol entries (length + bytes each)
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ ext: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        // Serialize protocol list to a typed [Byte] intermediate so the
        // length can be measured.
        var protocolListData: [Byte] = []
        for proto in ext.protocols {
            RFC_7301.ProtocolIdentifier.serialize(proto, into: &protocolListData)
        }

        // Extension type (16) — UInt16 wire form
        let extensionType: UInt16 = 16
        buffer.append(contentsOf: extensionType.bytes(endianness: .big))

        // Extension data length (2 + protocol list length) — UInt16 wire form
        let extensionLength = UInt16(2 + protocolListData.count)
        buffer.append(contentsOf: extensionLength.bytes(endianness: .big))

        // Protocol list length — UInt16 wire form
        let listLength = UInt16(protocolListData.count)
        buffer.append(contentsOf: listLength.bytes(endianness: .big))

        // Protocol list (already [Byte])
        buffer.append(contentsOf: protocolListData)
    }
}

// MARK: - Convenience Initializers

extension RFC_7301.Extension {
    /// Creates an ALPN extension for HTTP/2 with HTTP/1.1 fallback
    ///
    /// This is the most common configuration for HTTPS.
    public static var http2: Self {
        // Cannot throw because we're using well-known protocols
        try! Self(protocols: [.h2, .http1_1])
    }

    /// Creates an ALPN extension for HTTP/3
    public static var http3: Self {
        try! Self(protocols: [.h3])
    }

    /// Creates an ALPN extension for HTTP/1.1 only
    public static var http1_1: Self {
        try! Self(protocols: [.http1_1])
    }
}
