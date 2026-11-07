public import Binary
public import RFC_8446


extension RFC_7301.Extension {
    /// Errors that can occur when creating or parsing ALPN extensions
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Protocol list cannot be empty
        case noProtocols

        /// A `ProtocolName` entry in the list failed validation
        case name(RFC_7301.ProtocolIdentifier.Error)

        /// The input ended before a field was complete
        case truncated

        /// Bytes remained after the `ProtocolNameList` structure
        case trailingData(_ remaining: Int)
    }
}
