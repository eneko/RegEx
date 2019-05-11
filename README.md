# Regex
`NSRegularExpression` wrapper for easier use in Swift.

## Usage

```swift
let str = "16^32=2^128"
let regex = try Regex(pattern: #"\d+\^(\d+)"#) // Swift 5 raw string

let matches = regex.matches(in: str) // 2 matches with 1 captured group each
print(str[matches[0].groupRanges[0]]) // 32

print(regex.numberOfMatches(in: str)) // 2
print(regex.test(str)) // true
```


### Installation

No frameworks, just copy and paste!

```swift
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
```

