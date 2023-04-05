import Foundation

public extension [String: Any] {
    func value(forKey key: String) -> [Any]? {
        guard let v = self[key] as? [Any] else { return nil }
        return v
    }

    func value(forKey key: String) -> Bool? {
        if let v = self[key] as? Bool {
            return v
        } else if let v = self[key] as? NSNumber {
            return v.boolValue
        } else {
            return nil
        }
    }

    func value(forKey key: String) -> [String: Any]? {
        guard let v = self[key] as? [String: Any] else { return nil }
        return v
    }

    func value(forKey key: String) -> Double? {
        if let v = self[key] as? Double {
            return v
        } else if let v = self[key] as? Int {
            return Double(v)
        } else if let v = self[key] as? NSNumber {
            return v.doubleValue
        } else {
            return nil
        }
    }

    func value(forKey key: String) -> Int? {
        if let v = self[key] as? Int {
            return v
        } else if let v = self[key] as? Double {
            return Int(v)
        } else if let v = self[key] as? NSNumber {
            return v.intValue
        } else {
            return nil
        }
    }

    func value(forKey key: String) -> String? {
        guard let v = self[key] as? String else { return nil }
        return v
    }
}

public extension Optional where Wrapped == [String: Any] {
    func value(forKey key: String) -> [Any]? {
        guard let v = self?[key] as? [Any] else { return nil }
        return v
    }

    func value(forKey key: String) -> Bool? {
        if let v = self?[key] as? Bool {
            return v
        } else if let v = self?[key] as? NSNumber {
            return v.boolValue
        } else {
            return nil
        }
    }

    func value(forKey key: String) -> [String: Any]? {
        guard let v = self?[key] as? [String: Any] else { return nil }
        return v
    }

    func value(forKey key: String) -> Double? {
        if let v = self?[key] as? Double {
            return v
        } else if let v = self?[key] as? Int {
            return Double(v)
        } else if let v = self?[key] as? NSNumber {
            return v.doubleValue
        } else {
            return nil
        }
    }

    func value(forKey key: String) -> Int? {
        if let v = self?[key] as? Int {
            return v
        } else if let v = self?[key] as? Double {
            return Int(v)
        } else if let v = self?[key] as? NSNumber {
            return v.intValue
        } else {
            return nil
        }
    }

    func value(forKey key: String) -> String? {
        guard let v = self?[key] as? String else { return nil }
        return v
    }
}
