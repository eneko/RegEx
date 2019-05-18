# Regex
`NSRegularExpression` wrapper for easier regular expression data extraction in Swift.

## Usage

```swift
let str = "16^32=2^128"
let regex = try Regex(pattern: #"\d+\^(\d+)"#) // Swift 5 raw string

let matches = regex.matches(in: str) // 2 matches with 1 captured group each
print(matches[0].values) // ["16^32", "32"]
print(regex.numberOfMatches(in: str)) // 2
print(regex.test(str)) // true
```

### Extracting Data and Captured Groups with `matches(in:)`
This method allows for easy data extraction, including captured groups.

```swift
let matches = regex.matches(in: str)
```

The result of this method is a `Match` structure with one or more string ranges from the input string, 
as well as one or more values extracted as substrings. Using ranges and substrings avoids 
duplicating data from the input string.

```swift
str[matches[0].ranges[0]] // "16^32"
str[matches[0].ranges[1]] // 32
str[matches[1].ranges[0]] // "2^128"
str[matches[1].ranges[1]] // 128
```

## Installation

No frameworks, just copy and paste!

```swift
public struct Regex {
    private let regex: NSRegularExpression

    public init(pattern: String, options: NSRegularExpression.Options = []) throws {
        regex = try NSRegularExpression(pattern: pattern, options: options)
    }

    public struct Match {
        public let values: [Substring]
        public let ranges: [Range<String.Index>]
    }

    public func matches(in string: String) -> [Match] {
        let fullRange = NSRange(string.startIndex..., in: string)
        let results = regex.matches(in: string, range: fullRange)
        return results.map { result in
            let ranges = (0..<result.numberOfRanges).compactMap { index in
                Range(result.range(at: index), in: string)
            }
            return Match(values: ranges.map { string[$0] }, ranges: ranges)
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

### Swift Package Manager
Actually, I love unit tests, so I made this repo a Swift package that can be imported and used with
Swift Package Manager.

Add the following code to your `Package.swift` :

```
dependencies: [
    .package(url: "https://github.com/eneko/Regex.git", from: "0.1.0")
],
targets: {
    .target(name: "YourTarget", dependencies: ["Regex"])
}
```

## Unit Tests
If curious, you can run the tests with `$ swift test` or `$swift test --parallel`.
