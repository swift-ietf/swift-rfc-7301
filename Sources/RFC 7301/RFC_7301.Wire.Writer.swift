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

// RFC_7301.Wire.Writer.swift
// swift-rfc-7301
//
// TLS presentation language: append helpers

internal import Binary

extension RFC_7301.Wire {
    /// Appends a `uint16`-length-prefixed opaque vector.
    static func appendVector16<Buffer: RangeReplaceableCollection>(
        _ bytes: [Byte],
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(contentsOf: UInt16(bytes.count).bytes(endianness: .big))
        buffer.append(contentsOf: bytes)
    }
}
