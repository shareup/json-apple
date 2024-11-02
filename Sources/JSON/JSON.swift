import Foundation

public enum JSON:
    Hashable,
    CustomStringConvertible,
    Sendable
{
    indirect case array([JSON])
    case boolean(Bool)
    indirect case dictionary([String: JSON])
    case number(Double)
    case null
    case string(String)

    public init(_ array: [Any?]) {
        self = array.json
    }

    public init(_ dictionary: [String: Any?]) {
        self = dictionary.json
    }

    public subscript(key: String) -> JSON? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = newValue
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    public subscript(key: String) -> [Any?]? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]?.arrayValue
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = .array(newValue.compactMap(\.json))
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    public subscript(key: String) -> Bool? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]?.boolValue
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = .boolean(newValue)
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    public subscript(key: String) -> [String: Any?]? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]?.dictionaryValue
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = .dictionary(newValue.compactMapValues(\.json))
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    public subscript(key: String) -> Double? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]?.doubleValue
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = .number(newValue)
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    public subscript(key: String) -> Int? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]?.integerValue
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = .number(Double(newValue))
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    public subscript(key: String) -> String? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]?.stringValue
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = .string(newValue)
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    public subscript(index: Int) -> JSON? {
        get {
            guard case let .array(arr) = self, index < arr.count
            else { return nil }
            return arr[index]
        }
        set {
            guard case var .array(arr) = self else { return }
            arr[index] = newValue ?? .null
            self = .array(arr)
        }
    }

    /// Returns one of: `Array<Any>`, `Dictionary<String, Any>`,
    /// `Bool`, `NSNull`, `Double`, or `String`.
    public var rawValue: Any {
        switch self {
        case let .array(array):
            array.map(\.rawValue)

        case let .boolean(bool):
            bool

        case let .dictionary(dictionary):
            dictionary.mapValues(\.rawValue)

        case .null:
            NSNull()

        case let .number(number):
            number

        case let .string(string):
            string
        }
    }

    /// Returns a `Array<Any>` representation of the receiver.
    /// The returned value is suitable for encoding as JSON via
    /// `JSONSerialization.data(withJSONObject:options:)`.
    public var arrayValue: [Any]? {
        guard let json = rawValue as? [Any] else { return nil }
        return json
    }

    /// Returns a `Bool` representation of the receiver if the
    /// underlying type is `.boolean`, otherwise `nil`.
    public var boolValue: Bool? {
        guard let bool = rawValue as? Bool else { return nil }
        return bool
    }

    /// Returns a `Double` representation of the receiver if the
    /// underlying type is `.number`, otherwise `nil`.
    public var doubleValue: Double? {
        guard let double = rawValue as? Double else { return nil }
        return double
    }

    /// Returns a `Dictionary<String, Any>` representation of the receiver.
    /// The returned value is suitable for encoding as JSON via
    /// `JSONSerialization.data(withJSONObject:options:)`.
    public var dictionaryValue: [String: Any]? {
        guard let json = rawValue as? [String: Any] else { return nil }
        return json
    }

    /// Returns a `Int` representation of the receiver if the
    /// underlying type is `.number`, otherwise `nil`.
    public var integerValue: Int? {
        if let double = rawValue as? Double {
            Int(double)
        } else {
            nil
        }
    }

    /// Returns a `String` representation of the receiver if the
    /// underlying type is `.string`, otherwise `nil`.
    public var stringValue: String? {
        guard let string = rawValue as? String else { return nil }
        return string
    }

    /// Returns `true` if the receiver is an array, otherwise `false`.
    public var isArray: Bool {
        guard case .array = self else { return false }
        return true
    }

    /// Returns `true` if the receiver is a JSON object (a "dictionary"),
    /// otherwise `false`.
    public var isObject: Bool {
        guard case .dictionary = self else { return false }
        return true
    }

    public var description: String {
        String(describing: rawValue)
    }
}

extension JSON:
    ExpressibleByArrayLiteral,
    ExpressibleByBooleanLiteral,
    ExpressibleByDictionaryLiteral,
    ExpressibleByFloatLiteral,
    ExpressibleByIntegerLiteral,
    ExpressibleByNilLiteral,
    ExpressibleByStringLiteral
{
    public typealias ArrayLiteralElement = Any?
    public typealias FloatLiteralType = Double
    public typealias IntegerLiteralType = Int
    public typealias Key = String
    public typealias StringLiteralType = String
    public typealias Value = Any?

    public init(arrayLiteral elements: Any?...) {
        var array = [JSON]()
        for value in elements {
            guard let v = value.json else { continue }
            array.append(v)
        }
        self = .array(array)
    }

    public init(booleanLiteral value: BooleanLiteralType) {
        self = .boolean(value)
    }

    public init(dictionaryLiteral elements: (String, Any?)...) {
        var dictionary = [String: JSON]()
        for (key, value) in elements {
            guard let v = value.json else { continue }
            dictionary[key] = v
        }
        self = .dictionary(dictionary)
    }

    public init(floatLiteral value: Double) {
        self = .number(value)
    }

    public init(integerLiteral value: Int) {
        self = .number(Double(value))
    }

    public init(nilLiteral _: ()) {
        self = .null
    }

    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension JSON: Equatable {
    public static func == (_ arg1: JSON, _ arg2: JSON) -> Bool {
        switch (arg1, arg2) {
        case let (.array(one), .array(two)):
            one == two

        case let (.boolean(one), .boolean(two)):
            one == two

        case let (.dictionary(one), .dictionary(two)):
            one == two

        case let (.number(one), .number(two)):
            one == two

        case (.null, .null):
            true

        case let (.string(one), .string(two)):
            one == two

        default:
            false
        }
    }
}

extension JSON: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else if let bool = try? container.decode(Bool.self) {
            self = .boolean(bool)
        } else if let double = try? container.decode(Double.self) {
            self = .number(double)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode([JSON].self) {
            self = .array(array)
        } else if let dictionary = try? container.decode([String: JSON].self) {
            self = .dictionary(dictionary)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid JSON value."
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .null:
            try container.encodeNil()

        case let .boolean(bool):
            try container.encode(bool)

        case let .number(double):
            try container.encode(double)

        case let .string(string):
            try container.encode(string)

        case let .array(array):
            try container.encode(array)

        case let .dictionary(dictionary):
            try container.encode(dictionary)
        }
    }
}

public extension JSON? {
    subscript(key: String) -> JSON? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            dict[key] = newValue
            self = .dictionary(dict)
        }
    }

    subscript(key: String) -> [Any?]? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]?.arrayValue
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = .array(newValue.compactMap(\.json))
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    subscript(key: String) -> Bool? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]?.boolValue
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = .boolean(newValue)
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    subscript(key: String) -> [String: Any?]? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]?.dictionaryValue
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = .dictionary(newValue.compactMapValues(\.json))
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    subscript(key: String) -> Double? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]?.doubleValue
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = .number(newValue)
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    subscript(key: String) -> Int? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]?.integerValue
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = .number(Double(newValue))
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    subscript(key: String) -> String? {
        get {
            guard case let .dictionary(dict) = self else { return nil }
            return dict[key]?.stringValue
        }
        set {
            guard case var .dictionary(dict) = self else { return }
            if let newValue {
                dict[key] = .string(newValue)
            } else {
                dict.removeValue(forKey: key)
            }
            self = .dictionary(dict)
        }
    }

    subscript(index: Int) -> JSON? {
        get {
            guard case let .array(arr) = self, index < arr.count
            else { return nil }
            return arr[index]
        }
        set {
            guard case var .array(arr) = self else { return }
            arr[index] = newValue ?? .null
            self = .array(arr)
        }
    }

    /// Returns a `Array<Any>` representation of the receiver.
    /// The returned value is suitable for encoding as JSON via
    /// `JSONSerialization.data(withJSONObject:options:)`.
    var arrayValue: [Any]? {
        guard let json = self?.rawValue as? [Any] else { return nil }
        return json
    }

    /// Returns a `Bool` representation of the receiver if the
    /// underlying type is `.boolean`, otherwise `nil`.
    var boolValue: Bool? {
        guard let bool = self?.rawValue as? Bool else { return nil }
        return bool
    }

    /// Returns a `Double` representation of the receiver if the
    /// underlying type is `.number`, otherwise `nil`.
    var doubleValue: Double? {
        guard let double = self?.rawValue as? Double else { return nil }
        return double
    }

    /// Returns a `Dictionary<String, Any>` representation of the receiver.
    /// The returned value is suitable for encoding as JSON via
    /// `JSONSerialization.data(withJSONObject:options:)`.
    var dictionaryValue: [String: Any]? {
        guard let json = self?.rawValue as? [String: Any] else { return nil }
        return json
    }

    /// Returns a `Int` representation of the receiver if the
    /// underlying type is `.number`, otherwise `nil`.
    var integerValue: Int? {
        if let double = self?.rawValue as? Double {
            Int(double)
        } else {
            nil
        }
    }

    /// Returns a `String` representation of the receiver if the
    /// underlying type is `.string`, otherwise `nil`.
    var stringValue: String? {
        guard let string = self?.rawValue as? String else { return nil }
        return string
    }

    /// Returns `true` if the receiver is an array, otherwise `false`.
    var isArray: Bool {
        guard let self, self.isArray else { return false }
        return true
    }

    /// Returns `true` if the receiver is a JSON object (a "dictionary"),
    /// otherwise `false`.
    var isObject: Bool {
        guard let self, self.isObject else { return false }
        return true
    }

    static func == (_ arg1: JSON, _ arg2: JSON?) -> Bool {
        guard let arg2 else { return false }
        return arg1 == arg2
    }

    static func == (_ arg1: JSON?, _ arg2: JSON) -> Bool {
        guard let arg1 else { return false }
        return arg1 == arg2
    }

    static func == (_ arg1: String, _ arg2: JSON?) -> Bool {
        guard let arg2, case let .string(unwrapped) = arg2
        else { return false }
        return arg1 == unwrapped
    }

    static func == (_ arg1: JSON?, _ arg2: String) -> Bool {
        guard let arg1, case let .string(unwrapped) = arg1
        else { return false }
        return arg2 == unwrapped
    }

    static func == (_: NSNull, _ arg2: JSON?) -> Bool {
        guard let arg2 else { return true }
        guard case .null = arg2 else { return false }
        return true
    }

    static func == (_ arg1: JSON?, _: NSNull) -> Bool {
        guard let arg1 else { return true }
        guard case .null = arg1 else { return false }
        return true
    }

    static func == (_ arg1: Int, _ arg2: JSON?) -> Bool {
        guard let arg2, case let .number(unwrapped) = arg2
        else { return false }
        return arg1 == Int(unwrapped)
    }

    static func == (_ arg1: JSON?, _ arg2: Int) -> Bool {
        guard let arg1, case let .number(unwrapped) = arg1
        else { return false }
        return arg2 == Int(unwrapped)
    }

    static func == (_ arg1: Double, _ arg2: JSON?) -> Bool {
        guard let arg2, case let .number(unwrapped) = arg2
        else { return false }
        return arg1 == unwrapped
    }

    static func == (_ arg1: JSON?, _ arg2: Double) -> Bool {
        guard let arg1, case let .number(unwrapped) = arg1
        else { return false }
        return arg2 == unwrapped
    }

    static func == (_ arg1: Bool, _ arg2: JSON?) -> Bool {
        guard let arg2, case let .boolean(unwrapped) = arg2
        else { return false }
        return arg1 == unwrapped
    }

    static func == (_ arg1: JSON?, _ arg2: Bool) -> Bool {
        guard let arg1, case let .boolean(unwrapped) = arg1
        else { return false }
        return arg2 == unwrapped
    }
}

extension [Any?] {
    var json: JSON {
        .array(compactMap(\.json))
    }
}

public extension [String: Any?] {
    var json: JSON {
        var dictionary = [String: JSON]()
        for (key, value) in self {
            guard let v = value.json else { continue }
            dictionary[key] = v
        }
        return .dictionary(dictionary)
    }
}

private extension Any? {
    var json: JSON? {
        guard case let .some(element) = self else { return .null }

        switch element {
        case let e as [Any?]: return e.json
        case let e as [String: Any?]: return e.json
        case is NSNull: return .null
        case let e as NSNumber where e.isBool: return .boolean(e.boolValue)
        case let e as NSNumber: return .number(e.doubleValue)
        case let e as String: return .string(e)
        // The above cases should catch everything, but, in case they
        // don't, we try remaining types here.
        case let e as Bool: return .boolean(e)
        case let e as Double: return .number(e)
        case let e as Float: return .number(Double(e))
        case let e as Float32: return .number(Double(e))
        case let e as Int: return .number(Double(e))
        case let e as Int8: return .number(Double(e))
        case let e as Int16: return .number(Double(e))
        case let e as Int32: return .number(Double(e))
        case let e as Int64: return .number(Double(e))
        case let e as UInt: return .number(Double(e))
        case let e as UInt8: return .number(Double(e))
        case let e as UInt16: return .number(Double(e))
        case let e as UInt32: return .number(Double(e))
        case let e as UInt64: return .number(Double(e))
        case let e as JSON: return e
        default: return nil
        }
    }
}

private extension NSNumber {
    var isBool: Bool {
        CFBooleanGetTypeID() == CFGetTypeID(self)
    }
}
