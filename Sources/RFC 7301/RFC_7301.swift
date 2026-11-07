/// RFC 7301: TLS Application-Layer Protocol Negotiation Extension
///
/// This namespace contains types for ALPN as defined in RFC 7301 from July 2014.
///
/// ALPN allows the client and server to negotiate which application protocol
/// to use over a TLS connection.
///
/// ## Key Types
///
/// - ``ProtocolIdentifier``: Application protocol identifier
/// - ``Extension``: ALPN extension payload (`extension_data` body)
///
/// ## Usage
///
/// ALPN is used to negotiate protocols like HTTP/1.1, HTTP/2, or HTTP/3
/// during the TLS handshake, eliminating an extra round-trip.
///
/// ## Example
///
/// ```swift
/// // Create an ALPN extension with HTTP/2 and HTTP/1.1
/// let alpn = try RFC_7301.Extension(protocols: [.h2, .http1_1])
///
/// // Lift the payload into an enveloped extension for a ClientHello
/// let ext = try alpn.extensionData     // type == .alpn
/// ```
///
/// ## See Also
///
/// - [RFC 7301](https://www.rfc-editor.org/rfc/rfc7301)
/// - ``RFC_8446`` for TLS 1.3
public enum RFC_7301 {}

extension RFC_7301 {
    /// TLS extension type for ALPN
    ///
    /// Per RFC 7301 Section 3.1, ALPN uses extension type 16.
    public static let extensionType: UInt16 = 16
}
