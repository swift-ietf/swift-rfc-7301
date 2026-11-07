internal import Byte
public import RFC_7301

extension RFC_7301.ProtocolIdentifier {
    /// Stdlib-interop forwarder: construction from `[UInt8]` rawValue.
    @_disfavoredOverload
    public init(rawValue: [UInt8]) throws(Error) {
        try self.init(rawValue: rawValue.map(Byte.init(bitPattern:)))
    }
}
