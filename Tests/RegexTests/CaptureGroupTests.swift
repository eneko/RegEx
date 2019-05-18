//
//  CaptureGroupTests.swift
//  RegexTests
//
//  Created by Eneko Alonso on 5/18/19.
//

import XCTest
import Regex

class CaptureGroupTests: XCTestCase {

    /// Capturing group test
    /// https://www.regular-expressions.info/refcapture.html
    func testCapturingGroup() throws {
        let str = "abcabcabc"
        let regex = try Regex(pattern: "(abc){3}")
        let matches = regex.matches(in: str)

        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches[0].values.first, "abcabcabc")
        XCTAssertEqual(matches[0].ranges.count, 2)
        XCTAssertEqual(matches[0].values[1], "abc")
    }

    /// Non-Capturing group test
    /// https://www.regular-expressions.info/refcapture.html
    func testNonCapturingGroup() throws {
        let str = "abcabcabc"
        let regex = try Regex(pattern: "(?:abc){3}")
        let matches = regex.matches(in: str)

        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches[0].values.first, "abcabcabc")
        XCTAssertEqual(matches[0].ranges.count, 1)
    }

    /// Backreference group test
    /// https://www.regular-expressions.info/refcapture.html
    func testBackreferenceFirstGroup() throws {
        let regex = try Regex(pattern: #"(abc|def)=\1"#)
        XCTAssertTrue(regex.test("abc=abc"))
        XCTAssertTrue(regex.test("def=def"))
        XCTAssertFalse(regex.test("abc=def"))
        XCTAssertFalse(regex.test("def=abc"))
    }

    /// Backreference group test
    /// https://www.regular-expressions.info/refcapture.html
    func testBackreferenceSecondGroup() throws {
        let regex = try Regex(pattern: #"(a)(b)(c)(d)\2"#)
        XCTAssertTrue(regex.test("abcdb"))
        XCTAssertFalse(regex.test("abcde"))
    }

    /// Failed backreference
    /// https://www.regular-expressions.info/refcapture.html
    func testFailedBackreference() throws {
        let regex = try Regex(pattern: #"(a)?\1"#)
        XCTAssertEqual(regex.matches(in: "aa")[0].values[0], "aa")
        XCTAssertTrue(regex.matches(in: "b").isEmpty)
    }

    /// Case insensitive group
    /// https://javascript.info/regexp-groups
    func testCaseInsensitiveGroup() throws {
        let regex = try Regex(pattern: "(go)+", options: .caseInsensitive)
        XCTAssertEqual(regex.matches(in: "Gogogo now!")[0].values[0], "Gogogo")
    }

    /// Email regex
    /// https://javascript.info/regexp-groups
    func testEmail() throws {
        let regex = try Regex(pattern: #"[-.\w]+@([\w-]+\.)+[\w-]{2,20}"#)
        let matches = regex.matches(in: "my@mail.com @ his@site.com.uk")
        XCTAssertEqual(matches[0].values[0], "my@mail.com")
        XCTAssertEqual(matches[1].values[0], "his@site.com.uk")
    }

    /// Nested groups
    /// https://javascript.info/regexp-groups
    func testNestedGroups() throws {
        let regex = try Regex(pattern: #"<(([a-z]+)\s*([^>]*))>"#)
        let matches = regex.matches(in: #"<span class="my">"#)
        XCTAssertEqual(matches[0].values[0], "<span class=\"my\">")
        XCTAssertEqual(matches[0].values[1], "span class=\"my\"")
        XCTAssertEqual(matches[0].values[2], "span")
        XCTAssertEqual(matches[0].values[3], "class=\"my\"")
    }

    /// Missing groups
    /// https://javascript.info/regexp-groups
    func testMissingGroups() throws {
        let regex = try Regex(pattern: "a(z)?(c)?")
        let matches = regex.matches(in: "a")
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches[0].values.count, 3)
        XCTAssertEqual(matches[0].values[0], "a")
        XCTAssertNil(matches[0].values[1]) // no value for group (z)?
        XCTAssertNil(matches[0].values[2]) // no value for group (c)?
    }

    /// Missing groups
    /// https://javascript.info/regexp-groups
    func testMissingGroupsACK() throws {
        let regex = try Regex(pattern: "a(z)?(c)?")
        let matches = regex.matches(in: "ack")
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches[0].values.count, 3)
        XCTAssertEqual(matches[0].values[0], "ac")
        XCTAssertNil(matches[0].values[1]) // no value for group (z)?
        XCTAssertEqual(matches[0].values[2], "c")
    }

    /// Named groups
    /// https://javascript.info/regexp-groups
    func testNamedGroups() throws {
        let regex = try Regex(pattern: "(?<year>[0-9]{4})-(?<month>[0-9]{2})-(?<day>[0-9]{2})")
        let matches = regex.matches(in: "2019-04-30")
        XCTAssertEqual(matches[0].values[0], "2019-04-30")
        XCTAssertEqual(matches[0].values[1], "2019")
        XCTAssertEqual(matches[0].values[2], "04")
        XCTAssertEqual(matches[0].values[3], "30")
    }

}
