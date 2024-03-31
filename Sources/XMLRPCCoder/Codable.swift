// Copyright © 2024 Isaac Greenspan.  All rights reserved.

import Foundation
import MetaSerialization
import OrderedCollections

/// An object that encodes instances of a data type as XML-RPC style XML and decodes instances of a data type from
///  XML-RPC style XML.
public class XMLRPCCoder {
    let serializer: SimpleSerialization<XMLElement>

    /// Create a new, reusable XML-RPC encoder/decoder.
    public init() {
        serializer = SimpleSerialization<XMLElement>(
            translator: XMLRPCCoderMetaTranslator(),
            encodeFromMeta: convertToXMLRPC,
            decodeToMeta: convertToSwift
        )
    }

    /// Returns an XML-RPC style XML representation of the value you supply.
    /// - Parameter value: The value to encode as XML-RPC style XML.
    /// - Returns: An `XMLElement` containing the encoded XML.
    ///
    /// If there's a problem encoding the value you supply, this method throws
    /// `MetaEncoder.Errors.encodingHasNotSucceeded`.
    public func encode(_ value: some Encodable) throws -> XMLElement {
        try serializer.encode(value)
    }

    /// Returns a value of the type you specify, decoded from XML-RPC style XML.
    /// - Parameters:
    ///   - type: The type of the value to decode from the supplied XML-RPC style XML.
    ///   - raw: An `XMLElement` containing the XML.
    /// - Returns: A value of the specified type, if the decoder can parse the XML.
    ///
    /// If the XML isn't valid XML-RPC or a value within the XML fails to decode, this method throws
    /// `MetaDecoder.Errors.decodingHasNotSucceeded`.
    public func decode<D: Decodable>(toType type: D.Type, from raw: XMLElement) throws -> D {
        try serializer.decode(toType: type, from: raw)
    }
}

func convertToXMLRPC(_ value: Meta) throws -> XMLElement {
    if let primitive = value as? Primitive {
        return primitive.encoded

    } else if let array = value as? [Meta] {
        return XMLElement(name: .array, children: [
            XMLElement(name: .data, children: try array.map {
                XMLElement(name: .value, children: [try convertToXMLRPC($0)])
            }),
        ])

    } else if let dictionary = value as? OrderedDictionary<String, Meta> {
        return XMLElement(name: .struct, children: try dictionary.map { key, value in
            XMLElement(name: .member, children: [
                XMLElement(name: .name, stringValue: key),
                XMLElement(name: .value, children: [try convertToXMLRPC(value)]),
            ])
        })
    }
    throw MetaEncoder.Errors.encodingHasNotSucceeded
}

func convertToSwift(_ xmlrpc: XMLElement) throws -> Meta {
    guard
        let nodeNameString = xmlrpc.name,
        let nodeName = XMLNode.XMLRPCInternalNodeName(rawValue: nodeNameString)
    else { throw MetaDecoder.Errors.decodingHasNotSucceeded }

    switch nodeName {
    case .string:
        return try String.decode(xmlElement: xmlrpc)

    case .i4, .int:
        return try Int32.decode(xmlElement: xmlrpc)

    case .double:
        return try Double.decode(xmlElement: xmlrpc)

    case .boolean:
        return try Bool.decode(xmlElement: xmlrpc)

    case .datetime:
        return try Date.decode(xmlElement: xmlrpc)

    case .base64:
        return try Data.decode(xmlElement: xmlrpc)

    case .array:
        guard
            let data = xmlrpc.singleChild(named: .data),
            let array = try data.children?.map({ valueElement -> Meta in
                guard
                    let element = valueElement.singleChild as? XMLElement
                else { throw MetaDecoder.Errors.decodingHasNotSucceeded }
                return try convertToSwift(element)
            })
        else { throw MetaDecoder.Errors.decodingHasNotSucceeded }
        return array

    case .struct:
        guard let children = xmlrpc.children else { return [String: Meta]() }
        return OrderedDictionary(uniqueKeysWithValues: try children.map { node -> (String, Meta) in
            guard
                node.name == .member,
                let (nameNode, valueNode) = node.pairOfChildren(named: .name, and: .value),
                let nameString = nameNode.stringValue,
                let innerValueNode = valueNode.singleChild as? XMLElement
            else { throw MetaDecoder.Errors.decodingHasNotSucceeded }
            return (nameString, try convertToSwift(innerValueNode))
        })

    default:
        throw MetaDecoder.Errors.decodingHasNotSucceeded
    }
}
