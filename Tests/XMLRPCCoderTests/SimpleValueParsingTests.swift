// Copyright © 2024 Isaac Greenspan.  All rights reserved.

import XCTest
@testable import XMLRPCCoder

class SimpleValueParsingTests: XCTestCase {
    func testNonXMLStrings() {
        XCTAssertNil("".xmlrpcParseValue())
        XCTAssertNil("The quick brown fox jumps over the lazy dog.".xmlrpcParseValue())
    }

    func testValidXMLButNotRPC() {
        XCTAssertNil("<foo>bar</foo>".xmlrpcParseValue())
    }

    func testInvalidBool() {
        XCTAssertNil("<boolean>-1</boolean>".xmlrpcParseValue())
    }

    func testInvalidArray() {
        XCTAssertNil("<array>-1</array>".xmlrpcParseValue())
        XCTAssertNil("<array><data><foo></foo></data></array>".xmlrpcParseValue())
        XCTAssertNil("<array><data><value><string>bar</string><int>0</int></value></data></array>".xmlrpcParseValue())
        XCTAssertNil("<array><data><value><foo>bar</foo></value></data></array>".xmlrpcParseValue())
    }

    func testInt() {
        XCTAssertEqual("<i4>1234</i4>".xmlrpcParseValue() as? Int32, Int32(1234))
        XCTAssertEqual("<int>56789</int>".xmlrpcParseValue() as? Int32, Int32(56789))
    }

    func testBase64Data() {
        let parsed = "<base64>\nw6Vhw6k=\n</base64>\n".xmlrpcParseValue()
        XCTAssertEqual(parsed as? Data, "åaé".data(using: .utf8))
    }
}

extension String {
    func xmlrpcParseValue() -> Any? {
        guard let element = try? XMLElement(xmlString: self) else { return nil }
        return try? convertToSwift(element)
    }
}
