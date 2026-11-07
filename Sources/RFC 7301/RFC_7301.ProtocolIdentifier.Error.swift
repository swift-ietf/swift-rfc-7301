extension RFC_7301.ProtocolIdentifier {
    /// Errors that can occur when creating protocol identifiers
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Protocol identifier cannot be empty
        case empty

        /// Protocol identifier exceeds maximum length (255 bytes)
        case tooLong(_ length: Int)
    }
}

extension RFC_7301.ProtocolIdentifier.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "Protocol identifier cannot be empty"
        case .tooLong(let length):
            return "Protocol identifier too long: \(length) bytes (max 255)"
        }
    }
}
