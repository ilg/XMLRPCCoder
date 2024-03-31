// Copyright © 2024 Isaac Greenspan.  All rights reserved.

import MetaSerialization
import XCTest
@testable import XMLRPCCoder

class CodableInternalTests: XCTestCase {
    func testConvertToXMLRPCCatchAllThrow() {
        do {
            _ = try convertToXMLRPC(Int64(0)) // Int64 is too big to encode in XMLRPC
            XCTFail()
        } catch MetaEncoder.Errors.encodingHasNotSucceeded {
            XCTAssert(true)
        } catch {
            XCTFail("error: \(error)")
        }
    }

    func testConvertToSwiftCatchAllThrows() {
        // Test with a name that isn't in the internal node names enum.
        do {
            _ = try convertToSwift(XMLElement(name: "foo"))
            XCTFail()
        } catch MetaDecoder.Errors.decodingHasNotSucceeded {
            XCTAssert(true)
        } catch {
            XCTFail("error: \(error)")
        }
        // Test with a name that is in the internal node names enum, but isn't a proper value.
        do {
            _ = try convertToSwift(XMLElement(name: .data, children: []))
            XCTFail()
        } catch MetaDecoder.Errors.decodingHasNotSucceeded {
            XCTAssert(true)
        } catch {
            XCTFail("error: \(error)")
        }
    }
}
