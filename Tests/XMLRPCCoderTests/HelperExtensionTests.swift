// Copyright © 2024 Isaac Greenspan.  All rights reserved.

import XCTest
@testable import XMLRPCCoder

class HelperExtensionTests: XCTestCase {
    func testXMLElementConvenienceInit() {
        let name = "aName"
        let childName = "kid"
        let childValue = "the future"
        let child = XMLElement(name: childName, stringValue: childValue)
        let element = XMLElement(name: name, children: [child])
        XCTAssertEqual(element.name, name)
        XCTAssertEqual(element.children, [child])
    }
}
