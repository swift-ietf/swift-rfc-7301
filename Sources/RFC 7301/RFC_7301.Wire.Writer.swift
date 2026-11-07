internal import Binary

extension RFC_7301.Wire {
    /// Appends a `uint16`-length-prefixed opaque vector.
    static func appendVector16<Buffer: RangeReplaceableCollection>(
        _ bytes: [Byte],
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(contentsOf: UInt16(bytes.count).bytes(endianness: .big))
        buffer.append(contentsOf: bytes)
    }
}
