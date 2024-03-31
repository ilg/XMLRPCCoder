// Copyright © 2024 Isaac Greenspan.  All rights reserved.

import XCTest
import XMLAssertions
import XMLRPCCoder

class ComplexValueTests: XCTestCase {
    let coder = XMLRPCCoder()

    func testSerializingArraysInStructs() {
        struct Test: Codable {
            let FIRST: [String]
            let SECOND: String
            let THIRD: String
        }
        let xmlString = """
        <?xml version="1.0" encoding="UTF-8"?>
        <struct>
            <member>
                <name>FIRST</name>
                <value>
                    <array>
                        <data>
                            <value>
                                <string>ONE</string>
                            </value>
                            <value>
                                <string>TWO</string>
                            </value>
                        </data>
                    </array>
                </value>
            </member>
            <member>
                <name>SECOND</name>
                <value>
                    <string>TWO</string>
                </value>
            </member>
            <member>
                <name>THIRD</name>
                <value>
                    <string>THREE</string>
                </value>
            </member>
        </struct>
        """
        let test = Test(
            FIRST: ["ONE", "TWO"],
            SECOND: "TWO",
            THIRD: "THREE"
        )
        AssertXMLEqualToString(xml: try! coder.encode(test), string: xmlString)
        AssertXMLRPCValueStringRoundTrips(type: Test.self, xmlrpcValueString: xmlString)
    }

    func testLiveJournalPostEventExample() {
        let xmlString = """
        <struct>
            <member>
                <name>username</name>
                <value>
                    <string>test</string>
                </value>
            </member>
            <member>
                <name>password</name>
                <value>
                    <string>test</string>
                </value>
            </member>
            <member>
                <name>event</name>
                <value>
                    <string>This is a test post.
        </string>
                </value>
            </member>
            <member>
                <name>subject</name>
                <value>
                    <string>Test</string>
                </value>
            </member>
            <member>
                <name>lineendings</name>
                <value>
                    <string>pc</string>
                </value>
            </member>
            <member>
                <name>year</name>
                <value>
                    <i4>2002</i4>
                </value>
            </member>
            <member>
                <name>mon</name>
                <value>
                    <i4>7</i4>
                </value>
            </member>
            <member>
                <name>day</name>
                <value>
                    <i4>13</i4>
                </value>
            </member>
            <member>
                <name>hour</name>
                <value>
                    <i4>20</i4>
                </value>
            </member>
            <member>
                <name>min</name>
                <value>
                    <i4>35</i4>
                </value>
            </member>
        </struct>
        """
        struct Event: Codable {
            let username: String
            let password: String
            let event: String
            let subject: String
            let lineendings: String
            let year: Int32
            let mon: Int32
            let day: Int32
            let hour: Int32
            let min: Int32
        }
        let test = Event(
            username: "test",
            password: "test",
            event: """
            This is a test post.

            """,
            subject: "Test",
            lineendings: "pc",
            year: Int32(2002),
            mon: Int32(7),
            day: Int32(13),
            hour: Int32(20),
            min: Int32(35)
        )
        AssertXMLEqualToString(xml: try! coder.encode(test), string: xmlString)
        AssertXMLRPCValueStringRoundTrips(type: Event.self, xmlrpcValueString: xmlString)
    }

    func testLiveJournalGetFriendsResponseInner() {
        struct Friend: Codable {
            let fgcolor: String
            let username: String
            let fullname: String
            let bgcolor: String
            let type: String?
        }
        AssertXMLRPCValueStringRoundTrips(type: [Friend].self, xmlrpcValueString: """
        <array>

        <data>
        <value><struct>
        <member><name>fgcolor</name>
        <value><string>#000000</string></value>
        </member>

        <member><name>username</name>
        <value><string>bradfitz</string></value>
        </member>
        <member><name>fullname</name>

        <value><string>Brad Fitzpatrick</string></value>
        </member>
        <member><name>bgcolor</name>
        <value><string>#ffffff</string></value>

        </member>
        </struct></value>
        <value><struct>
        <member><name>fgcolor</name>
        <value><string>#efcfff</string></value>

        </member>
        <member><name>username</name>
        <value><string>ljfresno</string></value>
        </member>
        <member><name>fullname</name>

        <value><string>Fresno LJ users</string></value>
        </member>
        <member><name>bgcolor</name>
        <value><string>#000000</string></value>
        </member>
        <member><name>type</name>
        <value><string>community</string></value>

        </member>
        </struct></value>

        <value><struct>
        <member><name>fgcolor</name>
        <value><string>#520155</string></value>
        </member>
        <member><name>username</name>

        <value><string>webkin</string></value>
        </member>
        <member><name>fullname</name>
        <value><string>Ellen Stafford</string></value>

        </member>
        <member><name>bgcolor</name>
        <value><string>#fcddff</string></value>
        </member>
        </struct></value>

        </data>
        </array>
        """)
    }

    func testWordPressGetCommentsResponseInner() {
        struct Comment: Codable {
            let date_created_gmt: Date
            let user_id: String
            let comment_id: String
            let parent: String
            let status: String
            let content: String
            let link: String
            let post_id: String
            let post_title: String
            let author: String
            let author_url: String
            let author_email: String
            let author_ip: String
            let type: String
        }
        AssertXMLRPCValueStringRoundTrips(type: [Comment].self, xmlrpcValueString: """
        <array>
          <data>
            <value>
              <struct>
                <member>
                  <name>date_created_gmt</name>
                  <value>
                    <dateTime.iso8601>20081121T02:54:08</dateTime.iso8601>
                  </value>
                </member>
                <member>
                  <name>user_id</name>
                  <value>
                    <string>1</string>
                  </value>
                </member>
                <member>
                  <name>comment_id</name>
                  <value>
                    <string>8</string>
                  </value>
                </member>
                <member>
                  <name>parent</name>
                  <value>
                    <string>0</string>
                  </value>
                </member>
                <member>
                  <name>status</name>
                  <value>
                    <string>approve</string>
                  </value>
                </member>
                <member>
                  <name>content</name>
                  <value>
                    <string>Need more comments.</string>
                  </value>
                </member>
                <member>
                  <name>link</name>
                  <value>
                    <string>http://example.com/?p=41&amp;cpage=1#comment-8</string>
                  </value>
                </member>
                <member>
                  <name>post_id</name>
                  <value>
                    <string>41</string>
                  </value>
                </member>
                <member>
                  <name>post_title</name>
                  <value>
                    <string>This is a test post</string>
                  </value>
                </member>
                <member>
                  <name>author</name>
                  <value>
                    <string>admin</string>
                  </value>
                </member>
                <member>
                  <name>author_url</name>
                  <value>
                    <string>http://example.com/</string>
                  </value>
                </member>
                <member>
                  <name>author_email</name>
                  <value>
                    <string>example@example.com</string>
                  </value>
                </member>
                <member>
                  <name>author_ip</name>
                  <value>
                    <string>::1</string>
                  </value>
                </member>
                <member>
                  <name>type</name>
                  <value>
                    <string/>
                  </value>
                </member>
              </struct>
            </value>
            <value>
              <struct>
                <member>
                  <name>date_created_gmt</name>
                  <value>
                    <dateTime.iso8601>20081120T23:49:42</dateTime.iso8601>
                  </value>
                </member>
                <member>
                  <name>user_id</name>
                  <value>
                    <string>1</string>
                  </value>
                </member>
                <member>
                  <name>comment_id</name>
                  <value>
                    <string>7</string>
                  </value>
                </member>
                <member>
                  <name>parent</name>
                  <value>
                    <string>0</string>
                  </value>
                </member>
                <member>
                  <name>status</name>
                  <value>
                    <string>approve</string>
                  </value>
                </member>
                <member>
                  <name>content</name>
                  <value>
                    <string>Yet another comment.</string>
                  </value>
                </member>
                <member>
                  <name>link</name>
                  <value>
                    <string>http://example.com/?p=41&amp;cpage=1#comment-7</string>
                  </value>
                </member>
                <member>
                  <name>post_id</name>
                  <value>
                    <string>41</string>
                  </value>
                </member>
                <member>
                  <name>post_title</name>
                  <value>
                    <string>This is a test post</string>
                  </value>
                </member>
                <member>
                  <name>author</name>
                  <value>
                    <string>admin</string>
                  </value>
                </member>
                <member>
                  <name>author_url</name>
                  <value>
                    <string>http://example.com/</string>
                  </value>
                </member>
                <member>
                  <name>author_email</name>
                  <value>
                    <string>example@example.com</string>
                  </value>
                </member>
                <member>
                  <name>author_ip</name>
                  <value>
                    <string>::1</string>
                  </value>
                </member>
                <member>
                  <name>type</name>
                  <value>
                    <string/>
                  </value>
                </member>
              </struct>
            </value>
          </data>
        </array>
        """)
    }
}
