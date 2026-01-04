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

// MARK: - HTTP Protocols

extension RFC_7301.ProtocolIdentifier {
    /// HTTP/1.0 ("http/1.0")
    public static let http1_0 = Self(__unchecked: (), rawValue: Array("http/1.0".utf8))

    /// HTTP/1.1 ("http/1.1")
    public static let http1_1 = Self(__unchecked: (), rawValue: Array("http/1.1".utf8))

    /// HTTP/2 over TLS ("h2")
    public static let h2 = Self(__unchecked: (), rawValue: Array("h2".utf8))

    /// HTTP/2 over cleartext ("h2c")
    public static let h2c = Self(__unchecked: (), rawValue: Array("h2c".utf8))

    /// HTTP/3 ("h3")
    public static let h3 = Self(__unchecked: (), rawValue: Array("h3".utf8))

    /// SPDY/3.1 ("spdy/3.1")
    public static let spdy3_1 = Self(__unchecked: (), rawValue: Array("spdy/3.1".utf8))
}

// MARK: - Email Protocols

extension RFC_7301.ProtocolIdentifier {
    /// IMAP ("imap")
    public static let imap = Self(__unchecked: (), rawValue: Array("imap".utf8))

    /// POP3 ("pop3")
    public static let pop3 = Self(__unchecked: (), rawValue: Array("pop3".utf8))
}

// MARK: - Other Protocols

extension RFC_7301.ProtocolIdentifier {
    /// FTP ("ftp")
    public static let ftp = Self(__unchecked: (), rawValue: Array("ftp".utf8))

    /// STUN/TURN ("stun.turn")
    public static let stunTurn = Self(__unchecked: (), rawValue: Array("stun.turn".utf8))

    /// STUN/NAT discovery ("stun.nat-discovery")
    public static let stunNatDiscovery = Self(__unchecked: (), rawValue: Array("stun.nat-discovery".utf8))

    /// WebRTC ("webrtc")
    public static let webrtc = Self(__unchecked: (), rawValue: Array("webrtc".utf8))

    /// Confidential WebRTC ("c-webrtc")
    public static let cWebrtc = Self(__unchecked: (), rawValue: Array("c-webrtc".utf8))

    /// gRPC ("grpc-exp")
    public static let grpcExp = Self(__unchecked: (), rawValue: Array("grpc-exp".utf8))

    /// DNS over TLS ("dot")
    public static let dot = Self(__unchecked: (), rawValue: Array("dot".utf8))

    /// DNS over HTTPS ("doq")
    public static let doq = Self(__unchecked: (), rawValue: Array("doq".utf8))

    /// MQTT ("mqtt")
    public static let mqtt = Self(__unchecked: (), rawValue: Array("mqtt".utf8))
}
