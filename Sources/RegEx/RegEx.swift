//
//  RegEx.swift
//  RegEx
//
//  Created by Eneko Alonso on 5/13/19.
//
import Foundation

public class RegEx {
    private let regex: NSRegularExpression

    public init(pattern: String, options: NSRegularExpression.Options = []) throws {
        regex = try NSRegularExpression(pattern: pattern, options: options)
    }

    public struct Match {
        public let values: [Substring?]
        public let ranges: [Range<String.Index>?]
    }

    public func numberOfMatches(in string: String, from index: String.Index? = nil) -> Int {
        let startIndex = index ?? string.startIndex
        let range = NSRange(startIndex..., in: string)
        return regex.numberOfMatches(in: string, range: range)
    }

    public func firstMatch(in string: String, from index: String.Index? = nil) -> Match? {
        let startIndex = index ?? string.startIndex
        let range = NSRange(startIndex..., in: string)
        let result = regex.firstMatch(in: string, range: range)
        return result.flatMap { map(result: $0, in: string) }
    }

    public func matches(in string: String, from index: String.Index? = nil) -> [Match] {
        let startIndex = index ?? string.startIndex
        let range = NSRange(startIndex..., in: string)
        let results = regex.matches(in: string, range: range)
        return results.map { map(result: $0, in: string) }
    }

    public func test(_ string: String) -> Bool {
        return firstMatch(in: string) != nil
    }

    func map(result: NSTextCheckingResult, in string: String) -> Match {
        let ranges = (0..<result.numberOfRanges).map { index in
            Range(result.range(at: index), in: string)
        }
        let substrings = ranges.map { $0.flatMap { string[$0] }}
        return Match(values: substrings, ranges: ranges)
    }

}

// MARK: Text Replacement

extension RegEx {
    public func stringByReplacingMatches(in string: String, withTemplate template: String) -> String {
        let range = NSRange(string.startIndex..., in: string)
        return regex.stringByReplacingMatches(in: string, range: range, withTemplate: template)
    }

    public func stringByReplacingMatches(in string: String, replacement: (Match) -> String) -> String {
        var currentIndex = string.startIndex
        var output: [String] = []
        let iterator = self.iterator(for: string)
        while let match = iterator.next(), let matchRange = match.ranges[0] {
            output.append(String(string[currentIndex..<matchRange.lowerBound]))
            output.append(replacement(match))
            currentIndex = matchRange.upperBound
        }
        return output.joined()
    }
}

// MARK: Iterator

extension RegEx {
    public class Iterator: IteratorProtocol {
        let regex: RegEx
        let string: String
        var current: RegEx.Match?

        init(regex: RegEx, string: String) {
            self.regex = regex
            self.string = string
            current = regex.firstMatch(in: string)
        }

        public func next() -> RegEx.Match? {
            defer {
                current = current.flatMap {
                    let index = $0.ranges[0]?.upperBound
                    return self.regex.firstMatch(in: self.string, from: index)
                }
            }
            return current
        }
    }

    public func iterator(for string: String) -> Iterator {
        return Iterator(regex: self, string: string)
    }
}
