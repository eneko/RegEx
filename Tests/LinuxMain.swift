import XCTest

import RegExTests

var tests = [XCTestCaseEntry]()
tests += RegExTests.__allTests()

XCTMain(tests)
