//
//  NoOverlapTests.swift
//  RegexTests
//
//  Created by Eneko Alonso on 5/18/19.
//

import XCTest
import Regex

class NoOverlapTests: XCTestCase {

    func testNonOverlapping() throws {
        let regex = try Regex(pattern: "aa")
        let matches = regex.matches(in: "aaaa")
        XCTAssertEqual(matches.count, 2)
        XCTAssertEqual(matches[0].values.count, 1)
        XCTAssertEqual(matches[1].values.count, 1)
        XCTAssertEqual(matches[0].values[0], "aa")
        XCTAssertEqual(matches[1].values[0], "aa")
    }

    func testNonOverlappingGroups() throws {
        let regex = try Regex(pattern: "(aa)")
        let matches = regex.matches(in: "aaaa")
        XCTAssertEqual(matches.count, 2)
        XCTAssertEqual(matches[0].values.count, 2)
        XCTAssertEqual(matches[1].values.count, 2)
        XCTAssertEqual(matches[0].values[0], "aa")
        XCTAssertEqual(matches[0].values[1], "aa")
        XCTAssertEqual(matches[1].values[0], "aa")
        XCTAssertEqual(matches[1].values[1], "aa")
    }

}
