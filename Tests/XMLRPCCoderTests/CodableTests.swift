// Copyright © 2024 Isaac Greenspan.  All rights reserved.

import XCTest
import XMLAssertions
import XMLRPCCoder

private struct TestStruct: Codable, Equatable {
    let string: String
    let doubles: [Double]
    let int32s: [Int32]
    let bools: [Bool]
    let dates: [Date]
    let data: Data
}

class CodableTests: XCTestCase {
    let coder = XMLRPCCoder()

    func testDecodedStringMatchesStruct() {
        let decodeExpectedString = try! coder.decode(
            toType: TestStruct.self,
            from: try! XMLDocument(xmlString: testString).rootElement()!
        )
        XCTAssertEqual(decodeExpectedString, testStruct)
    }

    func testRoundTripStruct() throws {
        let encoded = try coder.encode(testStruct)
        AssertXMLEqualToString(xml: encoded, string: testString)
        let decoded = try coder.decode(toType: TestStruct.self, from: encoded)
        XCTAssertEqual(testStruct, decoded)
        XCTAssertEqual(testStruct.string, decoded.string)
        for (d1, d2) in zip(testStruct.doubles, decoded.doubles) {
            XCTAssertEqual(d1, d2, accuracy: 0.0000000001)
        }
        XCTAssertEqual(testStruct.int32s, decoded.int32s)
        XCTAssertEqual(testStruct.bools, decoded.bools)
        XCTAssertEqual(testStruct.dates, decoded.dates)
        XCTAssertEqual(testStruct.data, decoded.data)
    }
}

private let testStruct = TestStruct(
    string: "hi",
    doubles: [.pi, .leastNonzeroMagnitude, .leastNormalMagnitude, 0.3, -7.1, 12_345_678.9],
    int32s: [.max, .min, 0, -10, 256],
    bools: [true, false, false, true],
    dates: [DateComponents(
        calendar: Calendar(identifier: .gregorian),
        timeZone: TimeZone(abbreviation: "UTC"),
        // swiftformat:options:next --wraparguments preserve
        year: 1998, month: 7, day: 17,
        // swiftformat:options:next --wraparguments preserve
        hour: 14, minute: 8, second: 55
    ).date!],
    data: "unicode ïåeáî®©†µπœ∑".data(using: .utf8)!
)

private let testString = """
<?xml version="1.0" encoding="UTF-8"?>
<struct>
    <member>
        <name>string</name>
        <value>
            <string>hi</string>
        </value>
    </member>
    <member>
        <name>doubles</name>
        <value>
            <array>
                <data>
                    <value>
                        <double>3.141592653589793</double>
                    </value>
                    <value>
                        <double>5e-324</double>
                    </value>
                    <value>
                        <double>2.2250738585072014e-308</double>
                    </value>
                    <value>
                        <double>0.3</double>
                    </value>
                    <value>
                        <double>-7.1</double>
                    </value>
                    <value>
                        <double>12345678.9</double>
                    </value>
                </data>
            </array>
        </value>
    </member>
    <member>
        <name>int32s</name>
        <value>
            <array>
                <data>
                    <value>
                        <i4>2147483647</i4>
                    </value>
                    <value>
                        <i4>-2147483648</i4>
                    </value>
                    <value>
                        <i4>0</i4>
                    </value>
                    <value>
                        <i4>-10</i4>
                    </value>
                    <value>
                        <i4>256</i4>
                    </value>
                </data>
            </array>
        </value>
    </member>
    <member>
        <name>bools</name>
        <value>
            <array>
                <data>
                    <value>
                        <boolean>1</boolean>
                    </value>
                    <value>
                        <boolean>0</boolean>
                    </value>
                    <value>
                        <boolean>0</boolean>
                    </value>
                    <value>
                        <boolean>1</boolean>
                    </value>
                </data>
            </array>
        </value>
    </member>
    <member>
        <name>dates</name>
        <value>
            <array>
                <data>
                    <value>
                        <dateTime.iso8601>19980717T14:08:55</dateTime.iso8601>
                    </value>
                </data>
            </array>
        </value>
    </member>
    <member>
        <name>data</name>
        <value>
            <base64>dW5pY29kZSDDr8OlZcOhw67CrsKp4oCgwrXPgMWT4oiR</base64>
        </value>
    </member>
</struct>
"""
