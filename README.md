# JSON

JSON is a simple, type-safe JSON type implemented in pure Swift. It's intended to be lightweight and ergonomic. Most especially, it can be used in model value types that need to be sendable.

## Usage

```swift
let json: JSON = [
    "one": 2,
    "two_text": "two",
    "pi": 3.14,
    "yes": true,
    "null": nil,
    "object": [
        "three": 3,
        "four_text": "four",
        "null": nil,
        "inner_array": [
            "index_0",
            false,
            4.20,
        ] as [Any?],
    ] as [String: Any?],
]

json["one"].integerValue // 2
json["object"]["four_text"].stringValue // "four"
```

## Installation

### Swift Package Manager

To use JSON with the Swift Package Manager, add a dependency to your `Package.swift` file:
 
 ```swift
 let package = Package(
    dependencies: [
        .package(
            url: "https://github.com/shareup/json-apple.git", 
            from: "1.1.0"
        )
    ]
 )
```

## License

The license for JSON is the standard MIT licence. You can find it in the `LICENSE` file.
