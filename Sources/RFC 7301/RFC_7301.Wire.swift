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

// RFC_7301.Wire.swift
// swift-rfc-7301
//
// TLS presentation language (RFC 8446 Section 3 / RFC 5246 Section 4)
//
// Internal home for the presentation-language codec primitives the ALPN
// payload needs (uint8/uint16-length-prefixed vectors, big-endian integers).
// The extension payload routes its byte-level reads and writes through here so
// the length-prefix discipline lives in ONE place per [IMPL-060].
//
// RFC 8446 and RFC 6066 have identically-shaped `Wire` namespaces, but both
// are `internal` to their modules and therefore not reusable across the
// package boundary; this is a deliberate, minimal re-statement in the same
// style rather than a widening of either package's public surface.

extension RFC_7301 {
    /// Internal TLS presentation-language codec namespace.
    ///
    /// The TLS presentation language's only composite forms are fixed-width
    /// big-endian integers and length-prefixed opaque vectors
    /// (`opaque x<lo..hi>`). ``Wire`` centralizes the reading (``Wire/Reader``)
    /// and writing (append helpers) of those forms.
    enum Wire {}
}
