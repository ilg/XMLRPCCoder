// Copyright © 2024 Isaac Greenspan.  All rights reserved.

import Foundation

public extension XMLNode {
    /// Convenience accessor for getting the child node of a node that has exactly one child.
    var singleChild: XMLNode? {
        guard
            childCount == 1,
            let child = children?.first
        else { return nil }
        return child
    }

    /// Node names specifically used by XML-RPC.
    enum XMLRPCInternalNodeName: String {
        case member
        case name
        case value
        case data

        case methodCall
        case methodName

        case methodResponse
        case params
        case param
        case fault

        case string
        case i4
        case int
        case boolean
        case double
        case datetime = "dateTime.iso8601"
        case base64
        case array
        case `struct`
    }

    /// Convenience method for getting the child node of a node that has exactly one child and that child has the
    /// given node name.
    /// - Parameter requiredName: The XML-RPC node name the child should have
    /// - Returns: The child node
    func singleChild(named requiredName: XMLRPCInternalNodeName) -> XMLNode? {
        guard
            let child = singleChild,
            child.name == requiredName
        else { return nil }
        return child
    }

    /// Convenience method for getting the child nodes of a node that has exactly two children and the children have
    /// the given node names.
    /// - Parameters:
    ///   - firstName: The XML-RPC node name the first child should have
    ///   - secondName: The XML-RPC node name the second child should have
    /// - Returns: A tuple containing the two child nodes
    func pairOfChildren(named firstName: XMLRPCInternalNodeName, and secondName: XMLRPCInternalNodeName) -> (XMLNode, XMLNode)? {
        guard
            childCount == 2,
            let first = children?.first,
            let second = children?.last,
            first.name == firstName,
            second.name == secondName
        else { return nil }
        return (first, second)
    }
}

public extension String? {
    /// Equality operator for comparing the (optional) String version of a node name to an XML-RPC node name enum case.
    /// - Parameters:
    ///   - lhs: The optional String node name
    ///   - rhs: The XML-RPC node name
    /// - Returns: Whether the two node names are the same
    static func == (lhs: String?, rhs: XMLNode.XMLRPCInternalNodeName) -> Bool {
        lhs == rhs.rawValue
    }
}
