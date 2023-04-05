import JSON
import XCTest

final class DictionaryJSONTests: XCTestCase {
    func testValueForKey() throws {
        let original: [String: Any] = [
            "one": 1,
            "oneoh": 1.0,
            "onenum": NSNumber(value: 1),
            "pie": 3.14,
            "pienum": NSNumber(value: 3.14),
            "tru": true,
            "trunum": NSNumber(value: true),
            "fals": false,
            "falsnum": NSNumber(value: false),
        ]

        let json = JSON(original as [String: Any?])

        let dict = try XCTUnwrap(json.dictionaryValue)

        XCTAssertEqual(1, dict.intValue(forKey: "one"))
        XCTAssertEqual(1, dict.intValue(forKey: "oneoh"))
        XCTAssertEqual(1, dict.intValue(forKey: "onenum"))

        XCTAssertEqual(3.14, dict.doubleValue(forKey: "pie"))
        XCTAssertEqual(3.14, dict.doubleValue(forKey: "pienum"))

        XCTAssertEqual(3, dict.intValue(forKey: "pie"))
        XCTAssertEqual(3, dict.intValue(forKey: "pienum"))

        XCTAssertEqual(true, dict.boolValue(forKey: "tru"))
        XCTAssertEqual(true, dict.boolValue(forKey: "trunum"))

        XCTAssertEqual(false, dict.boolValue(forKey: "fals"))
        XCTAssertEqual(false, dict.boolValue(forKey: "falsnum"))

        XCTAssertNil(dict.boolValue(forKey: "one"))
        XCTAssertNil(dict.boolValue(forKey: "oneoh"))
        XCTAssertNil(dict.boolValue(forKey: "onenum"))

        XCTAssertNil(dict.doubleValue(forKey: "tru"))
        XCTAssertNil(dict.doubleValue(forKey: "fals"))

        XCTAssertNil(dict.intValue(forKey: "tru"))
        XCTAssertNil(dict.intValue(forKey: "fals"))
    }

    func testValueForKeyOfOptionalDictionary() throws {
        let original: [String: Any] = [
            "one": 1,
            "oneoh": 1.0,
            "onenum": NSNumber(value: 1),
            "pie": 3.14,
            "pienum": NSNumber(value: 3.14),
            "tru": true,
            "trunum": NSNumber(value: true),
            "fals": false,
            "falsnum": NSNumber(value: false),
        ]

        let json = JSON(original as [String: Any?])

        let dict = json.dictionaryValue

        XCTAssertEqual(1, dict.intValue(forKey: "one"))
        XCTAssertEqual(1, dict.intValue(forKey: "oneoh"))
        XCTAssertEqual(1, dict.intValue(forKey: "onenum"))

        XCTAssertEqual(3.14, dict.doubleValue(forKey: "pie"))
        XCTAssertEqual(3.14, dict.doubleValue(forKey: "pienum"))

        XCTAssertEqual(3, dict.intValue(forKey: "pie"))
        XCTAssertEqual(3, dict.intValue(forKey: "pienum"))

        XCTAssertEqual(true, dict.boolValue(forKey: "tru"))
        XCTAssertEqual(true, dict.boolValue(forKey: "trunum"))

        XCTAssertEqual(false, dict.boolValue(forKey: "fals"))
        XCTAssertEqual(false, dict.boolValue(forKey: "falsnum"))

        XCTAssertNil(dict.boolValue(forKey: "one"))
        XCTAssertNil(dict.boolValue(forKey: "oneoh"))
        XCTAssertNil(dict.boolValue(forKey: "onenum"))

        XCTAssertNil(dict.doubleValue(forKey: "tru"))
        XCTAssertNil(dict.doubleValue(forKey: "fals"))

        XCTAssertNil(dict.intValue(forKey: "tru"))
        XCTAssertNil(dict.intValue(forKey: "fals"))
    }
}
