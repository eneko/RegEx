//
//  IteratorTests.swift
//  RegExTests
//
//  Created by Eneko Alonso on 5/18/19.
//

import XCTest
import RegEx

class IteratorTests: XCTestCase {

    let loremIpsum = """
        Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat
        mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non,
        semper suscipit, posuere a, pede.

        Donec nec justo eget felis facilisis fermentum. Aliquam porttitor mauris sit amet orci.
        Aenean dignissim pellentesque felis.

        Morbi in sem quis dui placerat ornare. Pellentesque odio nisi, euismod in, pharetra a,
        ultricies in, diam. Sed arcu. Cras consequat.

        Praesent dapibus, neque id cursus faucibus, tortor neque egestas auguae, eu vulputate
        magna eros eu erat. Aliquam erat volutpat. Nam dui mi, tincidunt quis, accumsan
        porttitor, facilisis luctus, metus.

        Phasellus ultrices nulla quis nibh. Quisque a lectus. Donec consectetuer ligula
        vulputate sem tristique cursus. Nam nulla quam, gravida non, commodo a, sodales sit
        amet, nisi.
        """

    let regex = try? Regex(pattern: #"[a-zA-Z]+m\b"#)

    func testOneByOne() {
        let first = regex?.firstMatch(in: loremIpsum)
        XCTAssertEqual(first?.values[0], "Lorem")
        let nextIndex = first?.ranges[0]?.upperBound
        XCTAssertEqual(regex?.firstMatch(in: loremIpsum, from: nextIndex)?.values[0], "ipsum")
    }

    func testIterator() throws {
        let regex = try Regex(pattern: #"[a-zA-Z]+m\b"#)
        let iterator = regex.iterator(for: loremIpsum)
        XCTAssertEqual(iterator.next()?.values[0], "Lorem")
        XCTAssertEqual(iterator.next()?.values[0], "ipsum")
        XCTAssertEqual(iterator.next()?.values[0], "Nullam")
    }
}
