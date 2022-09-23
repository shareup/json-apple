import JSON
import XCTest

final class JSONTests: XCTestCase {
    func testCanEncodeToAndDecodeFromJSON() throws {
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

        let jsonValue = json.rawValue
        let jsonDictionary = try XCTUnwrap(json.dictionaryValue)

        let encodedValue = try JSONSerialization.data(
            withJSONObject: jsonValue,
            options: [.sortedKeys]
        )

        let encodedDictionary = try JSONSerialization.data(
            withJSONObject: jsonDictionary,
            options: [.sortedKeys]
        )

        XCTAssertEqual(encodedValue, encodedDictionary)

        let decodedValue = try JSONSerialization.jsonObject(with: encodedValue)
        let decodedDictionary = try JSONSerialization.jsonObject(with: encodedDictionary)

        let valueJSON = JSON(decodedValue as! [String: Any?])
        let dictionaryJSON = JSON(decodedDictionary as! [String: Any?])

        XCTAssertEqual(valueJSON, dictionaryJSON)
        XCTAssertEqual(json, dictionaryJSON)
    }

    func testSubscript() throws {
        let object: JSON = [
            "one": 1,
            "bool": true,
            "dict": [
                "key": "value",
            ],
        ]
        XCTAssertTrue(object["one"] == 1)
        XCTAssertFalse(object["one"] == "one")
        XCTAssertTrue(object["bool"] == true)
        XCTAssertFalse(object["bool"] == 2.0)
        XCTAssertTrue(JSON(["key": "value"]) == object["dict"])
        XCTAssertFalse(JSON.array([.string("one"), .boolean(false)]) == object["dict"])
        XCTAssertNil(object["doesNotExist"])
        XCTAssertEqual("value", object["dict"]["key"]?.stringValue)

        let array = JSON(["one", 2, false])
        XCTAssertTrue(array[0] == "one")
        XCTAssertTrue(array[1] == 2)
        XCTAssertTrue(array[2] == false)
        XCTAssertNil(array[3])

        let string: JSON = .string("text")
        XCTAssertNil(string["text"])
    }

    func testRawValue() throws {
        let arr = try XCTUnwrap(JSON(["one", nil, 123, 1.23]).rawValue as? [Any?])
        XCTAssertEqual("one", arr[0] as? String)
        XCTAssertEqual(NSNull(), arr[1] as? NSNull)
        XCTAssertEqual(123, Int(try XCTUnwrap(arr[2] as? Double)))
        XCTAssertEqual(1.23, arr[3] as? Double)

        XCTAssertEqual(true, JSON.boolean(true).rawValue as? Bool)
        XCTAssertEqual(false, JSON.boolean(false).rawValue as? Bool)

        let dict = try XCTUnwrap(JSON(["one": "one", "two": 1.23]).rawValue as? [String: Any?])
        XCTAssertEqual("one", dict["one"] as? String)
        XCTAssertEqual(1.23, dict["two"] as? Double)

        XCTAssertEqual(NSNull(), JSON.null.rawValue as? NSNull)

        XCTAssertEqual(3.14, JSON.number(3.14).rawValue as? Double)

        XCTAssertEqual("boom", JSON.string("boom").rawValue as? String)
    }

    func testSpecializedValues() throws {
        let arr = try XCTUnwrap(JSON(["one", nil, 123, 1.23]).arrayValue)
        XCTAssertEqual("one", arr[0] as? String)
        XCTAssertEqual(NSNull(), arr[1] as? NSNull)
        XCTAssertEqual(123, Int(try XCTUnwrap(arr[2] as? Double)))
        XCTAssertEqual(1.23, arr[3] as? Double)

        XCTAssertEqual(true, JSON.boolean(true).boolValue)
        XCTAssertEqual(false, JSON.boolean(false).boolValue)
        XCTAssertNil(JSON.number(0).boolValue)
        XCTAssertNil(JSON.number(1.0).boolValue)

        let dict = try XCTUnwrap(JSON(["one": "one", "two": 1.23]).dictionaryValue)
        XCTAssertEqual("one", dict["one"] as? String)
        XCTAssertEqual(1.23, dict["two"] as? Double)

        XCTAssertEqual(3.14, JSON.number(3.14).doubleValue)
        XCTAssertEqual(3, JSON.number(3.14).integerValue)
        XCTAssertEqual(1234, JSON.number(1234).integerValue)
        XCTAssertNil(JSON.string("1.23").doubleValue)
        XCTAssertNil(JSON.string("123").integerValue)

        XCTAssertEqual("boom", JSON.string("boom").stringValue)
    }

    func testOptionalSpecializedValues() throws {
        let arr: JSON? = JSON(["one", 123, 1.23])
        XCTAssertEqual(3, arr.arrayValue?.count)
        XCTAssertEqual("one", arr[0].stringValue)
        XCTAssertEqual(123, arr[1].integerValue)
        XCTAssertEqual(1.23, arr[2].doubleValue)

        XCTAssertEqual(true, (JSON.boolean(true) as JSON?).boolValue)
        XCTAssertEqual(false, (JSON.boolean(false) as JSON?).boolValue)
        XCTAssertNil((JSON.number(0) as JSON?).boolValue)
        XCTAssertNil((JSON.number(1.0) as JSON?).boolValue)

        let dict: JSON? = JSON(["one": "one", "two": 1.23])
        XCTAssertEqual(2, dict.dictionaryValue?.count)
        XCTAssertEqual("one", dict["one"].stringValue)
        XCTAssertEqual(1.23, dict["two"].doubleValue)

        XCTAssertEqual(3.14, (JSON.number(3.14) as JSON?).doubleValue)
        XCTAssertEqual(3, (JSON.number(3.14) as JSON?).integerValue)
        XCTAssertEqual(1234, (JSON.number(1234) as JSON?).integerValue)
        XCTAssertNil((JSON.string("1.23") as JSON?).doubleValue)
        XCTAssertNil((JSON.string("123") as JSON?).integerValue)

        XCTAssertEqual("boom", (JSON.string("boom") as JSON?).stringValue)
    }

    func testEquatable() throws {
        let arr: JSON? = JSON(["one", nil, 123, 1.23])
        XCTAssertTrue(arr == JSON(["one", nil, 123, 1.23]))
        XCTAssertTrue(JSON(["one", nil, 123, 1.23]) == arr)
        XCTAssertTrue(arr[0] == "one")
        XCTAssertTrue(arr[0] == "one")
        XCTAssertTrue(NSNull() == arr[1])
        XCTAssertTrue(arr[1] == NSNull())
        XCTAssertTrue(arr[2] == 123)
        XCTAssertTrue(arr[2] == 123)
        XCTAssertTrue(arr[3] == 1.23)
        XCTAssertTrue(arr[3] == 1.23)

        XCTAssertTrue(JSON.boolean(true) as JSON? == true)
        XCTAssertTrue(JSON.boolean(false) as JSON? == false)
        XCTAssertTrue(JSON.boolean(true) as JSON? == true)
        XCTAssertTrue(JSON.boolean(false) as JSON? == false)
        XCTAssertFalse(JSON.number(0) as JSON? == false)
        XCTAssertFalse(JSON.number(1) as JSON? == true)

        let dict: JSON? = JSON(["one": "one", "two": 1.23])
        XCTAssertTrue(dict == JSON(["one": "one", "two": 1.23]))
        XCTAssertTrue(JSON(["one": "one", "two": 1.23]) == dict)
        XCTAssertTrue(dict["one"] == "one")
        XCTAssertTrue(dict["one"] == "one")
        XCTAssertTrue(dict["two"] == 1.23)
        XCTAssertTrue(dict["two"] == 1.23)

        XCTAssertTrue(JSON.number(3.14) as JSON? == 3.14)
        XCTAssertTrue(JSON.number(3.14) as JSON? == 3.14)
        XCTAssertTrue(JSON.number(1234) as JSON? == 1234)

        XCTAssertTrue(JSON.string("boom") as JSON? == "boom")
        XCTAssertTrue(JSON.string("boom") as JSON? == "boom")
    }

    func testInitWithLiteralTypes() throws {
        XCTAssertEqual(
            JSON.array([.boolean(true), .number(3.14), .null]),
            [true, 3.14, nil]
        )

        XCTAssertEqual(JSON.boolean(false), false)
        XCTAssertEqual(JSON.boolean(true), true)

        XCTAssertEqual(
            JSON.dictionary(["one": .number(1), "two": .string("2")]),
            ["one": 1, "two": "2"]
        )

        XCTAssertEqual(JSON.number(3.14), 3.14)
        XCTAssertEqual(JSON.number(1234), 1234)

        XCTAssertEqual(JSON.null, nil)

        XCTAssertEqual(JSON.string("😊"), "😊")
    }
}
