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

// RFC_7301.ProtocolIdentifier.Error.swift
// swift-rfc-7301
//
// RFC 7301 Section 3.1: The Application-Layer Protocol Negotiation Extension

extension RFC_7301.ProtocolIdentifier {
    /// Errors that can occur when creating protocol identifiers
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Protocol identifier cannot be empty
        case empty

        /// Protocol identifier exceeds maximum length (255 bytes)
        case tooLong(_ length: Int)
    }
}

extension RFC_7301.ProtocolIdentifier.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "Protocol identifier cannot be empty"
        case .tooLong(let length):
            return "Protocol identifier too long: \(length) bytes (max 255)"
        }
    }
}
