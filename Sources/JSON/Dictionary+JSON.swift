import Foundation

public extension [String: Any] {
    func boolValue(forKey key: String) -> Bool? {
        if let v = self[key] as? Bool {
            return v
        } else if let v = self[key] as? NSNumber, v.isBool {
            return v.boolValue
        } else {
            return nil
        }
    }

    func doubleValue(forKey key: String) -> Double? {
        if let v = self[key] as? Double {
            return v
        } else if let v = self[key] as? NSNumber, !v.isBool {
            return v.doubleValue
        } else {
            return nil
        }
    }

    func intValue(forKey key: String) -> Int? {
        if let v = self[key] as? Int {
            return v
        } else if let v = self[key] as? Double {
            return Int(v)
        } else if let v = self[key] as? NSNumber, !v.isBool {
            return v.intValue
        } else {
            return nil
        }
    }
}

public extension [String: Any]? {
    func boolValue(forKey key: String) -> Bool? {
        if let v = self?[key] as? Bool {
            return v
        } else if let v = self?[key] as? NSNumber, v.isBool {
            return v.boolValue
        } else {
            return nil
        }
    }

    func doubleValue(forKey key: String) -> Double? {
        if let v = self?[key] as? Double {
            return v
        } else if let v = self?[key] as? NSNumber, !v.isBool {
            return v.doubleValue
        } else {
            return nil
        }
    }

    func intValue(forKey key: String) -> Int? {
        if let v = self?[key] as? Int {
            return v
        } else if let v = self?[key] as? Double {
            return Int(v)
        } else if let v = self?[key] as? NSNumber, !v.isBool {
            return v.intValue
        } else {
            return nil
        }
    }
}

private extension NSNumber {
    var isBool: Bool {
        CFBooleanGetTypeID() == CFGetTypeID(self)
    }
}
