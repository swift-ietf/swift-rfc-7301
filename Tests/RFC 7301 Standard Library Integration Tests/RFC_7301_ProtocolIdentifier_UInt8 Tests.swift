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

import RFC_7301
import RFC_7301_Standard_Library_Integration
import Testing

@Suite
struct `RFC 7301 ProtocolIdentifier UInt8 forwarder` {
    @Test
    func `forwarder constructs identifier from [UInt8]`() throws {
        let uint8Bytes: [UInt8] = Array("h2".utf8)
        let proto = try RFC_7301.ProtocolIdentifier(rawValue: uint8Bytes)
        #expect(proto.description == "h2")
    }

    @Test
    func `forwarder rejects empty [UInt8]`() {
        let uint8Bytes: [UInt8] = []
        #expect(throws: RFC_7301.ProtocolIdentifier.Error.self) {
            try RFC_7301.ProtocolIdentifier(rawValue: uint8Bytes)
        }
    }

    @Test
    func `forwarder rejects too-long [UInt8]`() {
        let uint8Bytes: [UInt8] = Array(repeating: 0x61, count: 256)
        #expect(throws: RFC_7301.ProtocolIdentifier.Error.self) {
            try RFC_7301.ProtocolIdentifier(rawValue: uint8Bytes)
        }
    }
}
