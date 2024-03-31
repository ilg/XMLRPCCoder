// Copyright © 2024 Isaac Greenspan.  All rights reserved.

import XCTest
import XMLAssertions
import XMLRPCCoder

class NaiveSerializableTests: XCTestCase {
    let coder = XMLRPCCoder()

    func testInt32IsSerializable() {
        let testInt32s: [Int32] = [.max, .min, 0, -10, 256]
        testInt32s.forEach { AssertXMLEqualToString(xml: try! coder.encode($0), string: "<i4>\($0)</i4>") }
    }

    func testBoolIsSerializable() {
        AssertXMLEqualToString(xml: try! coder.encode(true), string: "<boolean>1</boolean>")
        AssertXMLEqualToString(xml: try! coder.encode(false), string: "<boolean>0</boolean>")
    }

    func testStringIsSerializable() {
        let testString = "some string"
        AssertXMLEqualToString(xml: try! coder.encode(testString), string: "<string>\(testString)</string>")
    }

    func testDoubleIsSerializable() {
        let testDoubles: [Double] = [.pi, .greatestFiniteMagnitude, .leastNonzeroMagnitude, .leastNormalMagnitude, 0.3, -7.1, 12_345_678.9]
        testDoubles.forEach { AssertXMLEqualToString(xml: try! coder.encode($0), string: "<double>\($0)</double>") }
    }

    func testDateIsSerializable() {
        let utc = TimeZone(abbreviation: "UTC")
        let testDates: [String: Date?] = [
            "19980717T14:08:55": DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: utc, year: 1998, month: 7, day: 17, hour: 14, minute: 8, second: 55).date,
        ]
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withFullTime]
        for (dateString, date) in testDates {
            guard let date else {
                XCTFail()
                continue
            }
            AssertXMLEqualToString(xml: try! coder.encode(date), string: "<dateTime.iso8601>\(dateString)</dateTime.iso8601>")
        }
    }

    func testDataIsSerializable() {
        let testBase64String = "eW91IGNhbid0IHJlYWQgdGhpcyE="
        guard let data = Data(base64Encoded: testBase64String) else {
            XCTFail()
            return
        }
        AssertXMLEqualToString(xml: try! coder.encode(data), string: "<base64>\(testBase64String)</base64>")
    }
}
