# swift-rfc-7301

Use this package when you build or read the ALPN extension of a TLS handshake, to offer or pick an application protocol such as HTTP/2. Start from `RFC_7301.Extension`, with `RFC_7301.ProtocolIdentifier` for each protocol. For the rest of the TLS 1.3 handshake and the generic extension envelope, use swift-rfc-8446.

## Laws

- A protocol identifier is 1 to 255 opaque bytes. Identifiers compare byte for byte, so case matters.
- The protocol list is in preference order. `RFC_7301.Extension.selected` is its first entry, which in a server response is the chosen protocol.
- Writing an `RFC_7301.Extension` gives only the extension body: a 2-byte big-endian list length, then each identifier as a 1-byte length followed by its bytes. `RFC_7301.Extension.extensionData` adds the TLS extension envelope with type 16.
- Reading needs exactly one complete list. Input that ends early fails as truncated, leftover bytes fail as trailing data, an empty list fails as having no protocols, and an empty identifier fails as an invalid name.
- Reading doesn't check how many protocols there are, so a server response with more than one is accepted.
- An identifier encodes for `Codable` as its bytes decoded as UTF-8 text, and decodes by taking the UTF-8 bytes of that text.
