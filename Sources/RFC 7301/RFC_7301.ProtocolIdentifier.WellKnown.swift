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

// RFC_7301.ProtocolIdentifier.WellKnown.swift
// swift-rfc-7301
//
// Well-known ALPN protocol identifiers

import Byte

// MARK: - HTTP Protocols

extension RFC_7301.ProtocolIdentifier {
    /// HTTP/1.0 ("http/1.0")
    public static let http1_0 = Self(__unchecked: (), rawValue: [Byte](utf8: "http/1.0"))

    /// HTTP/1.1 ("http/1.1")
    public static let http1_1 = Self(__unchecked: (), rawValue: [Byte](utf8: "http/1.1"))

    /// HTTP/2 over TLS ("h2")
    public static let h2 = Self(__unchecked: (), rawValue: [Byte](utf8: "h2"))

    /// HTTP/2 over cleartext ("h2c")
    public static let h2c = Self(__unchecked: (), rawValue: [Byte](utf8: "h2c"))

    /// HTTP/3 ("h3")
    public static let h3 = Self(__unchecked: (), rawValue: [Byte](utf8: "h3"))

    /// SPDY/3.1 ("spdy/3.1")
    public static let spdy3_1 = Self(__unchecked: (), rawValue: [Byte](utf8: "spdy/3.1"))
}

// MARK: - Email Protocols

extension RFC_7301.ProtocolIdentifier {
    /// IMAP ("imap")
    public static let imap = Self(__unchecked: (), rawValue: [Byte](utf8: "imap"))

    /// POP3 ("pop3")
    public static let pop3 = Self(__unchecked: (), rawValue: [Byte](utf8: "pop3"))
}

// MARK: - Other Protocols

extension RFC_7301.ProtocolIdentifier {
    /// FTP ("ftp")
    public static let ftp = Self(__unchecked: (), rawValue: [Byte](utf8: "ftp"))

    /// STUN/TURN ("stun.turn")
    public static let stunTurn = Self(__unchecked: (), rawValue: [Byte](utf8: "stun.turn"))

    /// STUN/NAT discovery ("stun.nat-discovery")
    public static let stunNatDiscovery = Self(__unchecked: (), rawValue: [Byte](utf8: "stun.nat-discovery"))

    /// WebRTC ("webrtc")
    public static let webrtc = Self(__unchecked: (), rawValue: [Byte](utf8: "webrtc"))

    /// Confidential WebRTC ("c-webrtc")
    public static let cWebrtc = Self(__unchecked: (), rawValue: [Byte](utf8: "c-webrtc"))

    /// gRPC ("grpc-exp")
    public static let grpcExp = Self(__unchecked: (), rawValue: [Byte](utf8: "grpc-exp"))

    /// DNS over TLS ("dot")
    public static let dot = Self(__unchecked: (), rawValue: [Byte](utf8: "dot"))

    /// DNS over HTTPS ("doq")
    public static let doq = Self(__unchecked: (), rawValue: [Byte](utf8: "doq"))

    /// MQTT ("mqtt")
    public static let mqtt = Self(__unchecked: (), rawValue: [Byte](utf8: "mqtt"))
}
