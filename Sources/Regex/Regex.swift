//
//  Regex.swift
//  Regex
//
//  Created by Eneko Alonso on 5/13/19.
//
import Foundation

public struct Regex {
    private let regex: NSRegularExpression

    public init(pattern: String, options: NSRegularExpression.Options = []) throws {
        regex = try NSRegularExpression(pattern: pattern, options: options)
    }

    public struct Match {
        public let values: [Substring?]
        public let ranges: [Range<String.Index>?]
    }

    public func firstMatch(in string: String, from index: String.Index? = nil) -> Match? {
        let startIndex = index ?? string.startIndex
        let range = NSRange(startIndex..., in: string)
        let result = regex.firstMatch(in: string, range: range)
        return result.flatMap { map(result: $0, in: string) }
    }

    public func matches(in string: String) -> [Match] {
        let fullRange = NSRange(string.startIndex..., in: string)
        let results = regex.matches(in: string, range: fullRange)
        return results.map { map(result: $0, in: string) }
    }

    public func numberOfMatches(in string: String) -> Int {
        let fullRange = NSRange(string.startIndex..., in: string)
        return regex.numberOfMatches(in: string, range: fullRange)
    }

    public func test(_ string: String) -> Bool {
        return numberOfMatches(in: string) > 0
    }

    func map(result: NSTextCheckingResult, in string: String) -> Match {
        let ranges = (0..<result.numberOfRanges).map { index in
            Range(result.range(at: index), in: string)
        }
        let substrings = ranges.map { $0.flatMap { string[$0] }}
        return Match(values: substrings, ranges: ranges)
    }

}
