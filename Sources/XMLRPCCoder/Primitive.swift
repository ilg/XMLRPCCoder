// Copyright © 2024 Isaac Greenspan.  All rights reserved.

import Foundation
import MetaSerialization

protocol Primitive: Meta {
    var encoded: XMLElement { get }
    static func decode(xmlElement: XMLElement) throws -> Self
}

extension String: Primitive {
    static func decode(xmlElement: XMLElement) throws -> String {
        guard
            let value = xmlElement.stringValue
        else { throw MetaDecoder.Errors.decodingHasNotSucceeded }
        return value
    }

    var encoded: XMLElement {
        XMLElement(name: .string, stringValue: self)
    }
}

extension Int32: Primitive {
    static func decode(xmlElement: XMLElement) throws -> Int32 {
        guard
            let stringValue = xmlElement.stringValue,
            let value = Int32(stringValue)
        else { throw MetaDecoder.Errors.decodingHasNotSucceeded }
        return value
    }

    var encoded: XMLElement {
        XMLElement(name: .i4, stringValue: String(self))
    }
}

extension Double: Primitive {
    static func decode(xmlElement: XMLElement) throws -> Double {
        guard
            let stringValue = xmlElement.stringValue,
            let value = Double(stringValue)
        else { throw MetaDecoder.Errors.decodingHasNotSucceeded }
        return value
    }

    var encoded: XMLElement {
        XMLElement(name: .double, stringValue: String(self))
    }
}

extension Bool: Primitive {
    static func decode(xmlElement: XMLElement) throws -> Bool {
        guard
            let stringValue = xmlElement.stringValue
        else { throw MetaDecoder.Errors.decodingHasNotSucceeded }
        switch stringValue {
        case "0":
            return false
        case "1":
            return true
        default:
            throw MetaDecoder.Errors.decodingHasNotSucceeded
        }
    }

    var encoded: XMLElement {
        XMLElement(name: .boolean, stringValue: self ? "1" : "0")
    }
}

extension Date: Primitive {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyyMMdd'T'HH:mm:ss"
        return formatter
    }()

    static func decode(xmlElement: XMLElement) throws -> Date {
        guard
            let stringValue = xmlElement.stringValue,
            let date = Date.dateFormatter.date(from: stringValue)
        else { throw MetaDecoder.Errors.decodingHasNotSucceeded }
        return date
    }

    var encoded: XMLElement {
        XMLElement(name: .datetime, stringValue: Date.dateFormatter.string(from: self))
    }
}

extension Data: Primitive {
    static func decode(xmlElement: XMLElement) throws -> Data {
        guard
            let stringValue = xmlElement.stringValue,
            let data = Data(base64Encoded: stringValue, options: .ignoreUnknownCharacters)
        else { throw MetaDecoder.Errors.decodingHasNotSucceeded }
        return data
    }

    var encoded: XMLElement {
        XMLElement(name: .base64, stringValue: base64EncodedString())
    }
}
