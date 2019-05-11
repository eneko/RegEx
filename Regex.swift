import Foundation

public struct Regex {
    private let regex: NSRegularExpression

    public init(pattern: String, options: NSRegularExpression.Options = []) throws {
        regex = try NSRegularExpression(pattern: pattern, options: options)
    }

    public struct Match {
        public let range: Range<String.Index>
        public let groupRanges: [Range<String.Index>]
    }

    public func matches(in string: String) -> [Match] {
        let fullRange = NSRange(string.startIndex..., in: string)
        let results = regex.matches(in: string, range: fullRange)
        return results.map { result in
            var ranges = (0..<result.numberOfRanges).compactMap { index -> Range<String.Index>? in
                let range: NSRange = result.range(at: index)
                return Range(range, in: string)
            }
            return Match(range: ranges.removeFirst(), groupRanges: ranges)
        }
    }

    public func numberOfMatches(in string: String) -> Int {
        let fullRange = NSRange(string.startIndex..., in: string)
        return regex.numberOfMatches(in: string, range: fullRange)
    }

    public func test(_ string: String) -> Bool {
        return numberOfMatches(in: string) > 0
    }
}
