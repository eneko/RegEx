# RegEx
`RegEx` is a thin `NSRegularExpression` wrapper for easier regular expression testing, data extraction, and replacement in Swift.

![RegEx](/RegEx.png)

#### Features
- Test if a string matches the expression with `test()`
- Determine the number of matches in a string with `numberOfMatches(in:)`
- Retrieve all matches in a string with `matches(in:)`
- Retrieve the first match without processing all matches with `firstMatch(in:)`
- Efficiently **iterate over matches** with `iterator()` and `next()`
- Replace matches with a template (including capture groups)
- Replace matches one by one with **custom replacement logic** in a closure

The resulting `Match` structure contains the **full match**, any **captured groups**, and corresponding 
Swift **string ranges**.

By using `Range<String.Index>` and `Substring`, `RegEx.Match` is able to return all this information without
duplicating data from the input string 👏

## Usage

Given a string:
```swift
let str = "16^32=2^128"
```

Define an expression, for example to identify exponent notation (`^`) while 
capturing exponent values:
```swift
let expression = "\\d+\\^(\\d+)"
```

Use the regular expression:
```swift
let regex = try RegEx(pattern: expression)

regex.test(str) // true

regex.numberOfMatches(in: str) // 2

let first = regex.firstMatch(in: str) // 1 match with 1 captured group
first?.values // ["16^32", "32"] 

let matches = regex.matches(in: str) // 2 matches with 1 captured group each
matches[0].values // ["16^32", "32"] 
matches[1].values // ["2^128", "128"]
```

### Iterate over matches
```swift
let iterator = regex.iterator(for: str) // Iterate over matches one by one
iterator.next()?.values // ["16^32", "32"] 
iterator.next()?.values // ["2^128", "128"]
iterator.next()         // nil
```

### Replacement with Template
```swift
let regex = try RegEx(pattern: #"(\d)(\d)"#)
let result = regex.replaceMatches(in: "1234", withTemplate: "$2$1")
// result: 2143
```

### Replacement with Custom Logic
```swift
let regex = try RegEx(pattern: #"(\w+)\b"#)
let result = regex.replaceMatches(in: "Hello world!")  { match in 
    let value = String(match.values[0] ?? "")
    return String(value.reversed())
}
// result: olleH dlrow!
```

## Installation

No frameworks, just copy and paste!

```swift
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
```

### Swift Package Manager
Actually, I love unit tests, so I made this repo a Swift package that can be imported and used with
Swift Package Manager.

Add the following code to your `Package.swift` :

```
dependencies: [
    .package(url: "https://github.com/eneko/RegEx.git", from: "0.1.0")
],
targets: {
    .target(name: "YourTarget", dependencies: ["RegEx"])
}
```

## Unit Tests
If curious, you can run the tests with `$ swift test` or `$ swift test --parallel`.
