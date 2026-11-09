import ASCII
public import Binary
public import Byte

extension RFC_7301 {
    /// Application Protocol Identifier
    ///
    /// Protocol identifiers are opaque byte strings, typically ASCII.
    /// Well-known protocols are registered with IANA.
    ///
    /// ## Constraints
    ///
    /// Per RFC 7301:
    /// - Length: 1-255 bytes
    /// - Empty identifiers are not allowed
    ///
    /// ## Well-Known Protocols
    ///
    /// - HTTP/1.1: "http/1.1"
    /// - HTTP/2: "h2"
    /// - HTTP/2 over cleartext: "h2c"
    /// - HTTP/3: "h3"
    /// - SPDY/3.1: "spdy/3.1"
    public struct ProtocolIdentifier: Sendable, Hashable {
        /// The protocol identifier bytes (opaque byte-domain — typically ASCII)
        public let rawValue: [Byte]

        /// Creates a protocol identifier WITHOUT validation
        init(__unchecked: Void, rawValue: [Byte]) {
            self.rawValue = rawValue
        }

        /// Creates a protocol identifier with validation
        ///
        /// - Parameter rawValue: The protocol identifier bytes (1-255 bytes)
        /// - Throws: `Error` if validation fails
        public init(rawValue: [Byte]) throws(Error) {
            guard !rawValue.isEmpty else {
                throw Error.empty
            }
            guard rawValue.count <= 255 else {
                throw Error.tooLong(rawValue.count)
            }
            self.init(__unchecked: (), rawValue: rawValue)
        }

        /// Creates a protocol identifier from a string
        ///
        /// - Parameter string: The protocol identifier string
        /// - Throws: `Error` if validation fails
        public init(_ string: some StringProtocol) throws(Error) {
            try self.init(rawValue: string.utf8.map(Byte.init(bitPattern:)))
        }
    }
}

extension RFC_7301.ProtocolIdentifier {
    /// The number of bytes this identifier occupies on the wire: the length
    /// byte and the identifier bytes.
    var encodedLength: Int {
        1 + rawValue.count
    }
}

extension RFC_7301.ProtocolIdentifier: Binary.Serializable {
    /// Serializes the protocol identifier
    ///
    /// Format: length (1 byte) + identifier bytes
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ proto: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(Byte(UInt8(proto.rawValue.count)))
        buffer.append(contentsOf: proto.rawValue)
    }
}

extension RFC_7301.ProtocolIdentifier: CustomStringConvertible {
    public var description: String {
        String(decoding: rawValue, as: UTF8.self)
    }
}

extension RFC_7301.ProtocolIdentifier: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        do {
            try self.init(string as String)
        } catch {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Invalid protocol identifier: \(error)"
                )
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
