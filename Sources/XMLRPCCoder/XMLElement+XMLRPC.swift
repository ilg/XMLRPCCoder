// Copyright © 2024 Isaac Greenspan.  All rights reserved.

import Foundation

public extension XMLElement {
    /// Convenience method for creating an `XMLElement` with the given name and child nodes.
    /// - Parameters:
    ///   - name: The name of the element
    ///   - children: The child nodes
    convenience init(name: String, children: [XMLNode]) {
        self.init(name: name)
        setChildren(children)
    }

    /// Convenience method for creating an `XMLElement` with the given XML-RPC node name and child nodes.
    /// - Parameters:
    ///   - name: The XML-RPC node name
    ///   - children: The child nodes
    convenience init(name: XMLNode.XMLRPCInternalNodeName, children: [XMLNode]) {
        self.init(name: name.rawValue, children: children)
    }

    /// Convenience method for creating an `XMLElement` with the given XML-RPC node name and string value.
    /// - Parameters:
    ///   - name: The XML-RPC node name
    ///   - stringValue: The string value
    convenience init(name: XMLNode.XMLRPCInternalNodeName, stringValue: String) {
        self.init(name: name.rawValue, stringValue: stringValue)
    }
}
