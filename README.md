# XMLRPCCoder

[![Build & Test][buildtest-image]][buildtest-url]
[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![codebeat-badge][codebeat-image]][codebeat-url]

Provides the ability to encode/decode Swift `Codable` types to XML-RPC style XML. 

Foundation for [XMLRPCClient](/ilg/XMLRPCClient/) and [XMLRPCServer](/ilg/XMLRPCServer).

Built with [MetaSerialization](/cherrywoods/swift-meta-serialization/).

## Installation

Add this project on your `Package.swift`

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(
            url: "https://github.com/ilg/XMLRPCCoder.git", 
            branch: "main"
        )
    ]
)
```

## Usage example


```swift
import XMLRPCCoder

struct GetChallengeResponse: Codable {
    let auth_scheme: String
    let challenge: String
    let expire_time: Int32
    let server_time: Int32
}

let xmlDocument = try XMLDocument(xmlString:"""
<?xml version="1.0" encoding="UTF-8"?>
<methodResponse>
    <params>
        <param>
            <value>
                <struct>
                    <member>
                        <name>auth_scheme</name>
                        <value>
                            <string>c0</string>
                        </value>
                    </member>
                    <member>
                        <name>challenge</name>
                        <value>
                            <string>c0:1073113200:2831:60:2TCbFBYR72f2jhVDuowz:0fba728f5964ea54160a5b18317d92df</string>
                        </value>
                    </member>
                    <member>
                        <name>expire_time</name>
                        <value>
                            <int>1073116091</int>
                        </value>
                    </member>
                    <member>
                        <name>server_time</name>
                        <value>
                            <int>1073116031</int>
                        </value>
                    </member>
                </struct>
            </value>
        </param>
    </params>
</methodResponse>
""")

let coder = XMLRPCCoder()

let challengeResponse = try coder.decode(toType: GetChallengeResponse.self, from: xmlDocument.rootElement()!)

let xmlElement = try coder.encode(challengeResponse) 
```


## Development setup

Open [Package.swift](Package.swift), which should open the whole package in Xcode.  Tests can be run in Xcode.

Alternately, `swift test` to run the tests at the command line.

Use `bin/format` to auto-format all the Swift code.

[buildtest-image]:https://github.com/ilg/XMLRPCCoder/actions/workflows/build-and-test.yml/badge.svg
[buildtest-url]:https://github.com/ilg/XMLRPCCoder/actions/workflows/build-and-test.yml
[swift-image]:https://img.shields.io/badge/Swift-5.8-green.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[codebeat-image]: https://codebeat.co/badges/1c3ce768-69bf-41bd-aee5-48cc8c027419
[codebeat-url]: https://codebeat.co/projects/github-com-ilg-xmlrpccoder-main
