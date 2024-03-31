// Copyright © 2024 Isaac Greenspan.  All rights reserved.

import Foundation
import MetaSerialization
import OrderedCollections

struct XMLRPCCoderMetaTranslator: MetaSupplier & Unwrapper {
    private let underlyingTranslator = PrimitivesProtocolTranslator<Primitive, Primitive.Type>()

    func wrap(_ value: some Encodable, for encoder: MetaEncoder) throws -> Meta? {
        try underlyingTranslator.wrap(value, for: encoder)
    }

    func unwrap<T>(meta: Meta, toType type: T.Type, for decoder: MetaDecoder) throws -> T? where T: Decodable {
        try underlyingTranslator.unwrap(meta: meta, toType: type, for: decoder)
    }

    func keyedContainerMeta() -> EncodingKeyedContainerMeta {
        OrderedDictionary<String, Meta>()
    }
}

extension OrderedDictionary: KeyedContainerMeta, Meta where Key == String, Value == Meta {
    /// For MetaSerialization.
    public func contains(key: MetaCodingKey) -> Bool {
        self[key.stringValue] != nil
    }

    /// For MetaSerialization.
    public func getValue(for key: MetaCodingKey) -> Meta? {
        self[key.stringValue]
    }

    /// For MetaSerialization.
    public var allKeys: [MetaCodingKey] {
        keys.map { MetaCodingKey(stringValue: $0) }
    }

    /// For MetaSerialization.
    public mutating func put(_ value: Meta, for key: MetaCodingKey) {
        self[key.stringValue] = value
    }
}
