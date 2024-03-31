// Copyright © 2024 Isaac Greenspan.  All rights reserved.

import XCTest
import XMLRPCCoder

private func normalize(xmlString: String) throws -> String {
    try XMLElement(xmlString: xmlString).xmlString
}

/// Assert that the given XML node is equivalent to the given XML string.  Both are round-tripped through XMLElement
/// so as to normalize representation, whitespace, etc.
///
/// - Parameters:
///   - xml: The XML node
///   - string: The XML string
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func AssertXMLEqualToString(
    xml: XMLNode,
    string: String,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertEqual(try normalize(xmlString: xml.xmlString), try normalize(xmlString: string), file: file, line: line)
}

/// Assert that a `Codable` type can decode the given XML string and matches (up to normalization) the given XML
/// string when re-encoded.
///
/// - Parameters:
///   - type: The `Codable` type
///   - xmlString: The XML string
///   - coder: An optional specific instance of `XMLRPCCoder` to use.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
public func AssertXMLRPCValueStringRoundTrips(
    type: (some Codable).Type,
    xmlrpcValueString xmlString: String,
    coder: XMLRPCCoder = XMLRPCCoder(),
    file: StaticString = #file,
    line: UInt = #line
) {
    let xml: XMLElement
    do {
        xml = try XMLElement(xmlString: xmlString)
    } catch {
        XCTFail("Parsing XML string failed", file: file, line: line)
        return
    }
    guard let parsed = try? coder.decode(toType: type, from: xml) else {
        XCTFail("Parsing XML into XMLRPC value failed", file: file, line: line)
        return
    }
    AssertXMLEqualToString(
        xml: try! coder.encode(parsed),
        string: xmlString,
        file: file,
        line: line
    )
    XCTAssertEqual(xml.xmlString.count, (try! coder.encode(parsed)).xmlString.count, file: file, line: line)
}
