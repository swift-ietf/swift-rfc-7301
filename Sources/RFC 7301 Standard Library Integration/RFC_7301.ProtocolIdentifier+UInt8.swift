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

// RFC_7301.ProtocolIdentifier+UInt8.swift
//
// Stdlib-interop UInt8 forwarder for ALPN protocol identifier construction.
// Primary byte-domain API lives in `RFC 7301`; this forwarder bridges stdlib
// callers carrying `[UInt8]` (e.g. from network buffers, file reads) via
// bit pattern. Per [API-BYTE-007] (byte-discipline skill).

internal import Byte
public import RFC_7301

extension RFC_7301.ProtocolIdentifier {
    /// Stdlib-interop forwarder: construction from `[UInt8]` rawValue.
    @_disfavoredOverload
    public init(rawValue: [UInt8]) throws(Error) {
        try self.init(rawValue: rawValue.map(Byte.init(bitPattern:)))
    }
}
