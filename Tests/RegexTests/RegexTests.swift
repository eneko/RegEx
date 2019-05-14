import XCTest
import Regex

final class RegexTests: XCTestCase {

    func testExponents() throws {
        let str = "16^32=2^128"
        let regex = try Regex(pattern: #"\d+\^(\d+)"#)
        let matches = regex.matches(in: str)

        XCTAssertEqual(matches.count, 2)

        XCTAssertEqual(str[matches[0].range], "16^32")
        XCTAssertEqual(matches[0].groupRanges.count, 1)
        XCTAssertEqual(str[matches[0].groupRanges[0]], "32")

        XCTAssertEqual(str[matches[1].range], "2^128")
        XCTAssertEqual(matches[1].groupRanges.count, 1)
        XCTAssertEqual(str[matches[1].groupRanges[0]], "128")
    }

    /// Capturing group test
    /// https://www.regular-expressions.info/refcapture.html
    func testCapturingGroup() throws {
        let str = "abcabcabc"
        let regex = try Regex(pattern: "(abc){3}")
        let matches = regex.matches(in: str)

        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(str[matches[0].range], "abcabcabc")
        XCTAssertEqual(matches[0].groupRanges.count, 1)
        XCTAssertEqual(str[matches[0].groupRanges[0]], "abc")
    }

    /// Non-Capturing group test
    /// https://www.regular-expressions.info/refcapture.html
    func testNonCapturingGroup() throws {
        let str = "abcabcabc"
        let regex = try Regex(pattern: "(?:abc){3}")
        let matches = regex.matches(in: str)

        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(str[matches[0].range], "abcabcabc")
        XCTAssertEqual(matches[0].groupRanges.count, 0)
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
        XCTAssertEqual(regex.substrings(from: "aa")[0][0], "aa")
        XCTAssertTrue(regex.substrings(from: "b").isEmpty)
    }

    func testNonOverlapping() throws {
        let regex = try Regex(pattern: "aa")
        XCTAssertEqual(regex.substrings(from: "aaaa")[0][0], "aa")
        XCTAssertEqual(regex.substrings(from: "aaaa")[1][0], "aa")
    }

    func testNonOverlappingGroups() throws {
        let regex = try Regex(pattern: "(aa)")
        XCTAssertEqual(regex.substrings(from: "aaaa")[0][0], "aa")
        XCTAssertEqual(regex.substrings(from: "aaaa")[0][1], "aa")
        XCTAssertEqual(regex.substrings(from: "aaaa")[1][0], "aa")
        XCTAssertEqual(regex.substrings(from: "aaaa")[1][1], "aa")
    }

}
