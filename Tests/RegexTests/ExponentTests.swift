//
//  ExponentTests.swift
//  RegexTests
//
//  Created by Eneko Alonso on 5/13/19.
//

import XCTest
import Regex

final class ExponentTests: XCTestCase {

    func testExponents() throws {
        let str = "16^32=2^128"
        let regex = try Regex(pattern: #"\d+\^(\d+)"#)
        let matches = regex.matches(in: str)

        XCTAssertEqual(matches.count, 2)

        XCTAssertEqual(matches[0].values.first, "16^32")
        XCTAssertEqual(matches[0].ranges.count, 2)
        XCTAssertEqual(matches[0].values[1], "32")

        XCTAssertEqual(matches[1].values.first, "2^128")
        XCTAssertEqual(matches[1].ranges.count, 2)
        XCTAssertEqual(matches[1].values[1], "128")
    }

    func testExponentsStarStar() throws {
        let str = "16**32=2**128"
        let regex = try Regex(pattern: #"\d+\*\*(\d+)"#)
        let matches = regex.matches(in: str)

        XCTAssertEqual(matches.count, 2)

        XCTAssertEqual(matches[0].values.first, "16**32")
        XCTAssertEqual(matches[0].ranges.count, 2)
        XCTAssertEqual(matches[0].values[1], "32")

        XCTAssertEqual(matches[1].values.first, "2**128")
        XCTAssertEqual(matches[1].ranges.count, 2)
        XCTAssertEqual(matches[1].values[1], "128")
    }
}
