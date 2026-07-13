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

import Testing
import Binary_Serializable_Primitives
import RFC_8446

@testable import RFC_7301

@Suite("RFC 7301 ALPN Tests")
struct RFC7301Tests {

    @Suite("Constants Tests")
    struct ConstantsTests {
        @Test
        func `Extension type is 16`() {
            #expect(RFC_7301.extensionType == 16)
        }
    }

    @Suite("Protocol Identifier Tests")
    struct ProtocolIdentifierTests {
        @Test
        func `Well-known protocols`() {
            #expect(RFC_7301.ProtocolIdentifier.http1_1.description == "http/1.1")
            #expect(RFC_7301.ProtocolIdentifier.h2.description == "h2")
            #expect(RFC_7301.ProtocolIdentifier.h3.description == "h3")
            #expect(RFC_7301.ProtocolIdentifier.h2c.description == "h2c")
        }

        @Test
        func `Create custom protocol`() throws {
            let proto = try RFC_7301.ProtocolIdentifier("my-protocol")
            #expect(proto.description == "my-protocol")
        }

        @Test
        func `Reject empty protocol`() {
            #expect(throws: RFC_7301.ProtocolIdentifier.Error.self) {
                try RFC_7301.ProtocolIdentifier(rawValue: [])
            }
        }

        @Test
        func `Reject too long protocol`() {
            let longBytes: [Byte] = Array(repeating: Byte(0x61), count: 256)

            #expect(throws: RFC_7301.ProtocolIdentifier.Error.self) {
                try RFC_7301.ProtocolIdentifier(rawValue: longBytes)
            }
        }

        @Test
        func `Serialize protocol identifier`() {
            let proto = RFC_7301.ProtocolIdentifier.h2

            var buffer: [Byte] = []
            RFC_7301.ProtocolIdentifier.serialize(proto, into: &buffer)

            // 1 byte length + 2 bytes "h2"
            #expect(buffer.count == 3)
            #expect(buffer[0] == 2)  // length
            #expect(buffer[1] == 0x68)  // 'h'
            #expect(buffer[2] == 0x32)  // '2'
        }
    }

    @Suite("Extension Tests")
    struct ExtensionTests {
        @Test
        func `Create extension with protocols`() throws {
            let ext = try RFC_7301.Extension(protocols: [.h2, .http1_1])

            #expect(ext.protocols.count == 2)
            #expect(ext.selected == .h2)
        }

        @Test
        func `Reject empty protocol list`() {
            #expect(throws: RFC_7301.Extension.Error.self) {
                try RFC_7301.Extension(protocols: [])
            }
        }

        @Test
        func `Create server response`() {
            let ext = RFC_7301.Extension(selected: .h2)

            #expect(ext.protocols.count == 1)
            #expect(ext.selected == .h2)
        }

        @Test
        func `Convenience constructors`() {
            #expect(RFC_7301.Extension.http2.protocols.contains(.h2))
            #expect(RFC_7301.Extension.http2.protocols.contains(.http1_1))
            #expect(RFC_7301.Extension.http3.protocols == [.h3])
            #expect(RFC_7301.Extension.http1_1.protocols == [.http1_1])
        }

        @Test
        func `Serialize extension body`() throws {
            let ext = try RFC_7301.Extension(protocols: [.h2])

            var buffer: [Byte] = []
            RFC_7301.Extension.serialize(ext, into: &buffer)

            // Body only: list length (2) + protocol (1+2)
            #expect(buffer.count == 5)

            // Protocol list length = 3
            #expect(buffer[0] == 0)
            #expect(buffer[1] == 3)

            // Protocol: length + "h2"
            #expect(buffer[2] == 2)
            #expect(buffer[3] == 0x68)  // 'h'
            #expect(buffer[4] == 0x32)  // '2'
        }

        @Test
        func `Serialize multiple protocols`() throws {
            let ext = try RFC_7301.Extension(protocols: [.h2, .http1_1])

            var buffer: [Byte] = []
            RFC_7301.Extension.serialize(ext, into: &buffer)

            // Body only: list length (2) + h2 (3) + http/1.1 (9)
            #expect(buffer.count == 14)
        }

        @Test
        func `Extension data envelope is byte-identical to the pre-migration envelope form`() throws {
            let ext = try RFC_7301.Extension(protocols: [.h2])

            var buffer: [Byte] = []
            RFC_8446.Extension.Data.serialize(ext.extensionData, into: &buffer)

            // Envelope: type (2) + length (2) + list length (2) + protocol (1+2).
            // These are the exact bytes RFC_7301.Extension.serialize emitted
            // BEFORE the body-level migration — continuity evidence.
            #expect(buffer == [0, 16, 0, 5, 0, 3, 2, 0x68, 0x32])
        }

        @Test
        func `Extension type is alpn`() {
            #expect(RFC_7301.Extension.extensionType == .alpn)
            #expect(RFC_7301.Extension.extensionType.rawValue == RFC_7301.extensionType)
            #expect(RFC_7301.Extension.http2.extensionData.type == .alpn)
        }
    }

    @Suite("Extension Parse Tests")
    struct ExtensionParseTests {
        @Test
        func `Parse single-protocol body`() throws {
            let body: [Byte] = [0, 3, 2, 0x68, 0x32]  // list len 3; "h2"

            let ext = try RFC_7301.Extension(binary: body)

            #expect(ext.protocols == [.h2])
            #expect(ext.selected == .h2)
        }

        @Test
        func `Round-trip multiple protocols`() throws {
            let original = try RFC_7301.Extension(protocols: [.h2, .http1_1])

            let parsed = try RFC_7301.Extension(binary: original.bytes)

            #expect(parsed == original)
        }

        @Test
        func `Round-trip server response`() throws {
            let original = RFC_7301.Extension(selected: .h3)

            let parsed = try RFC_7301.Extension(binary: original.bytes)

            #expect(parsed == original)
            #expect(parsed.selected == .h3)
        }

        @Test
        func `Reject empty list body`() {
            // Valid vector16 of length 0 — an empty protocol_name_list.
            #expect(throws: RFC_7301.Extension.Error.noProtocols) {
                try RFC_7301.Extension(binary: [0, 0] as [Byte])
            }
        }

        @Test
        func `Reject zero-length protocol name`() {
            // List of one entry whose ProtocolName length is 0.
            #expect(throws: RFC_7301.Extension.Error.name(.empty)) {
                try RFC_7301.Extension(binary: [0, 1, 0] as [Byte])
            }
        }

        @Test
        func `Reject truncated input`() {
            let full: [Byte] = [0, 3, 2, 0x68, 0x32]
            for cut in 0..<full.count {
                #expect(throws: RFC_7301.Extension.Error.truncated) {
                    try RFC_7301.Extension(binary: Array(full.prefix(cut)))
                }
            }
        }

        @Test
        func `Reject trailing data`() {
            // Complete list followed by one stray byte.
            #expect(throws: RFC_7301.Extension.Error.trailingData(1)) {
                try RFC_7301.Extension(binary: [0, 3, 2, 0x68, 0x32, 0xFF] as [Byte])
            }
        }
    }

    @Suite("Additional Protocols Tests")
    struct AdditionalProtocolsTests {
        @Test
        func `Transport protocols`() {
            #expect(RFC_7301.ProtocolIdentifier.imap.description == "imap")
            #expect(RFC_7301.ProtocolIdentifier.pop3.description == "pop3")
            #expect(RFC_7301.ProtocolIdentifier.ftp.description == "ftp")
        }

        @Test
        func `WebRTC protocols`() {
            #expect(RFC_7301.ProtocolIdentifier.webrtc.description == "webrtc")
            #expect(RFC_7301.ProtocolIdentifier.cWebrtc.description == "c-webrtc")
            #expect(RFC_7301.ProtocolIdentifier.stunTurn.description == "stun.turn")
        }

        @Test
        func `DNS protocols`() {
            #expect(RFC_7301.ProtocolIdentifier.dot.description == "dot")
            #expect(RFC_7301.ProtocolIdentifier.doq.description == "doq")
        }
    }
}
