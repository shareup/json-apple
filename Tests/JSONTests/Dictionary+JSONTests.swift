import XCTest
import JSON

final class DictionaryJSONTests: XCTestCase {
    func testValueForKey() throws {
        let original = [
            "one": 1,
            "two": "2",
            "pie": 3.14,
            "arr": [1, 2.0, false, "yes", nil] as [Any?],
            "obj": [
                "none": nil,
                "tru": true,
                "yes": "yes",
                "twenty": 20,
                "body": 98.6,
            ] as [String: Any?]
        ] as [String: Any?]

        let json = original.json
        XCTAssertNil(json.arrayValue)
        XCTAssertNil(json.stringValue)

        let dict = try XCTUnwrap(json.dictionaryValue)

        if let v: Int = dict.value(forKey: "one") {
            XCTAssertEqual(1, v)
        } else {
            XCTFail("Should have unwrapped value")
        }

        if let v: Double = dict.value(forKey: "pie") {
            XCTAssertEqual(3.14, v)
        } else {
            XCTFail("Should have unwrapped value")
        }

        if let v: Int = dict.value(forKey: "pie") {
            XCTAssertEqual(3, v)
        } else {
            XCTFail("Should have unwrapped value")
        }

        if let v: Int = (dict["obj"] as? [String: Any])?.value(forKey: "twenty") {
            XCTAssertEqual(20, v)
        } else {
            XCTFail("Should have unwrapped value")
        }

        if let v: Double = (dict["obj"] as? [String: Any])?.value(forKey: "twenty") {
            XCTAssertEqual(20.0, v)
        } else {
            XCTFail("Should have unwrapped value")
        }

        if let v: Int = (dict["obj"] as? [String: Any])?.value(forKey: "none") {
            XCTFail("Should not have unwrapped \(v) for nil")
        }
    }

    func testValueForKeyOnOptionalDictionary() throws {
        let original = [
            "one": 1,
            "two": "2",
            "pie": 3.14,
            "arr": [1, 2.0, false, "yes", nil] as [Any?],
            "obj": [
                "none": nil,
                "tru": true,
                "yes": "yes",
                "twenty": 20,
                "body": 98.6,
            ] as [String: Any?]
        ] as [String: Any?]

        let json = original.json
        XCTAssertNil(json.arrayValue)
        XCTAssertNil(json.stringValue)

        let dict = json.dictionaryValue

        if let v: Int = dict.value(forKey: "one") {
            XCTAssertEqual(1, v)
        } else {
            XCTFail("Should have unwrapped value")
        }

        if let v: Double = dict.value(forKey: "pie") {
            XCTAssertEqual(3.14, v)
        } else {
            XCTFail("Should have unwrapped value")
        }

        if let v: Int = dict.value(forKey: "pie") {
            XCTAssertEqual(3, v)
        } else {
            XCTFail("Should have unwrapped value")
        }

        if let v: Int = (dict?["obj"] as? [String: Any])?.value(forKey: "twenty") {
            XCTAssertEqual(20, v)
        } else {
            XCTFail("Should have unwrapped value")
        }

        if let v: Double = (dict?["obj"] as? [String: Any])?.value(forKey: "twenty") {
            XCTAssertEqual(20.0, v)
        } else {
            XCTFail("Should have unwrapped value")
        }

        if let v: Int = (dict?["obj"] as? [String: Any])?.value(forKey: "none") {
            XCTFail("Should not have unwrapped \(v) for nil")
        }
    }
}
