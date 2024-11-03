import Foundation

public extension [String: Any] {
    func boolValue(forKey key: String) -> Bool? {
        if let v = self[key] as? Bool {
            v
        } else if let v = self[key] as? NSNumber, v.isBool {
            v.boolValue
        } else {
            nil
        }
    }

    func doubleValue(forKey key: String) -> Double? {
        if let v = self[key] as? Double {
            v
        } else if let v = self[key] as? NSNumber, !v.isBool {
            v.doubleValue
        } else {
            nil
        }
    }

    func intValue(forKey key: String) -> Int? {
        if let v = self[key] as? Int {
            v
        } else if let v = self[key] as? Double {
            Int(v)
        } else if let v = self[key] as? NSNumber, !v.isBool {
            v.intValue
        } else {
            nil
        }
    }
}

public extension [String: Any]? {
    func boolValue(forKey key: String) -> Bool? {
        if let v = self?[key] as? Bool {
            v
        } else if let v = self?[key] as? NSNumber, v.isBool {
            v.boolValue
        } else {
            nil
        }
    }

    func doubleValue(forKey key: String) -> Double? {
        if let v = self?[key] as? Double {
            v
        } else if let v = self?[key] as? NSNumber, !v.isBool {
            v.doubleValue
        } else {
            nil
        }
    }

    func intValue(forKey key: String) -> Int? {
        if let v = self?[key] as? Int {
            v
        } else if let v = self?[key] as? Double {
            Int(v)
        } else if let v = self?[key] as? NSNumber, !v.isBool {
            v.intValue
        } else {
            nil
        }
    }
}

private extension NSNumber {
    var isBool: Bool {
        CFBooleanGetTypeID() == CFGetTypeID(self)
    }
}
