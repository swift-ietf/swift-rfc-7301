public import Binary
public import RFC_8446

extension RFC_7301 {
    /// `application_layer_protocol_negotiation` extension payload
    /// (`extension_data` body) — ALPN.
    ///
    /// Carries the list of protocols the client supports (in ClientHello)
    /// or the selected protocol (in ServerHello/EncryptedExtensions).
    ///
    /// ## Wire Format
    ///
    /// ```
    /// opaque ProtocolName<1..2^8-1>;
    ///
    /// struct {
    ///     ProtocolName protocol_name_list<2..2^16-1>
    /// } ProtocolNameList;
    /// ```
    ///
    /// In a ClientHello the list carries the supported protocols in preference
    /// order; in a server response it carries exactly one protocol (the
    /// selected one).
    ///
    /// ## Serialization Convention
    ///
    /// This type serializes the **body** (`extension_data` contents) only, not
    /// the `extension_type` + length envelope — the RFC 8446 payload
    /// convention shared with the RFC 6066 payloads. Use ``extensionData`` to
    /// lift the body into an ``RFC_8446/Extension/Data``.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let alpn = try RFC_7301.Extension(protocols: [.h2, .http1_1])
    /// let ext = try alpn.extensionData     // type == .alpn
    /// ```
    public struct Extension: Sendable, Hashable {
        /// List of supported protocols (in preference order)
        public let protocols: [ProtocolIdentifier]

        /// Creates an ALPN extension WITHOUT validation
        init(__unchecked: Void, protocols: [ProtocolIdentifier]) {
            self.protocols = protocols
        }

        /// Creates an ALPN extension
        ///
        /// - Parameter protocols: List of protocols in preference order
        /// - Throws: `Error.noProtocols` if list is empty
        public init(protocols: [ProtocolIdentifier]) throws(Error) {
            guard !protocols.isEmpty else {
                throw Error.noProtocols
            }
            self.init(__unchecked: (), protocols: protocols)
        }

        /// Creates an ALPN extension with a single protocol (for server response)
        ///
        /// - Parameter selected: The selected protocol
        public init(selected: ProtocolIdentifier) {
            self.init(__unchecked: (), protocols: [selected])
        }
    }
}

extension RFC_7301.Extension {
    /// The selected protocol (first in list)
    ///
    /// In a server response, this is the negotiated protocol.
    public var selected: RFC_7301.ProtocolIdentifier? {
        protocols.first
    }

    /// The extension type for this payload
    /// (`application_layer_protocol_negotiation`).
    public static let extensionType: RFC_8446.Extension.ExtensionType = .alpn

    /// Wraps this payload in a generic ``RFC_8446/Extension/Data`` envelope.
    ///
    /// - Throws: ``RFC_8446/Extension/Data/Error`` if the body exceeds the
    ///   envelope's 65535-byte limit.
    public var extensionData: RFC_8446.Extension.Data {
        get throws(RFC_8446.Extension.Data.Error) {
            try RFC_8446.Extension.Data(type: Self.extensionType, data: self.bytes)
        }
    }
}

extension RFC_7301.Extension {
}

extension RFC_7301.Extension.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .noProtocols:
            return "ALPN extension requires at least one protocol"
        case .name(let error):
            return "ALPN protocol name invalid: \(error)"
        case .truncated:
            return "ALPN extension body truncated"
        case .trailingData(let remaining):
            return "ALPN extension body has \(remaining) trailing byte(s)"
        }
    }
}

extension RFC_7301.Extension: Binary.Serializable {
    /// Serializes the ALPN `extension_data` body.
    ///
    /// Format:
    /// - Protocol list length (2 bytes)
    /// - Protocol entries (1-byte length + bytes each)
    ///
    /// The `extension_type` + length envelope is NOT emitted here; lift the
    /// body via ``extensionData`` for the enveloped form.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ ext: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        var protocolNameList: [Byte] = []
        for proto in ext.protocols {
            RFC_7301.ProtocolIdentifier.serialize(proto, into: &protocolNameList)
        }
        RFC_7301.Wire.appendVector16(protocolNameList, into: &buffer)
    }

    /// Parses an ALPN `extension_data` body.
    ///
    /// - Parameter bytes: Exactly one `ProtocolNameList`; trailing bytes are
    ///   rejected.
    public init<Bytes: Swift::Collection>(binary bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        let entries: [[Byte]]
        do throws(RFC_7301.Wire.Error) {
            var reader = RFC_7301.Wire.Reader(Array(bytes))
            var list = RFC_7301.Wire.Reader(try reader.vector16())
            try reader.expectEnd()
            var collected: [[Byte]] = []
            while !list.isAtEnd {
                collected.append(try list.vector8())
            }
            entries = collected
        } catch {
            switch error {
            case .trailingData(let remaining): throw .trailingData(remaining)
            case .truncated, .lengthOverflow: throw .truncated
            }
        }

        guard !entries.isEmpty else { throw .noProtocols }

        var protocols: [RFC_7301.ProtocolIdentifier] = []
        for entry in entries {
            do throws(RFC_7301.ProtocolIdentifier.Error) {
                protocols.append(try RFC_7301.ProtocolIdentifier(rawValue: entry))
            } catch {
                throw .name(error)
            }
        }
        self.init(__unchecked: (), protocols: protocols)
    }
}

extension RFC_7301.Extension {
    /// Creates an ALPN extension for HTTP/2 with HTTP/1.1 fallback
    ///
    /// This is the most common configuration for HTTPS.
    public static var http2: Self {
        // swiftlint:disable:next force_try
        try! Self(protocols: [.h2, .http1_1])
    }

    /// Creates an ALPN extension for HTTP/3
    public static var http3: Self {
        // swiftlint:disable:next force_try
        try! Self(protocols: [.h3])
    }

    /// Creates an ALPN extension for HTTP/1.1 only
    public static var http1_1: Self {
        // swiftlint:disable:next force_try
        try! Self(protocols: [.http1_1])
    }
}
