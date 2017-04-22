//
//  DecodeWithRootKeyPath.swift
//  JSONTypedDecoder
//
//  Created by 林 達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import XCTest
import JSONTypedDecoder

class DecodeWithRootKeyPathTest: XCTestCase {

    lazy var JSON: JSONDictionary = {
        return [
            "name": "name",
            "floor": 123,
            "optional": [ "foo", "bar" ]
            ]
    }()

    func testDecodeWithRootKeyValue() {
        let objectWithValue: JSONDictionary = [ "group": JSON ]

        var group: Group?

        group = try? decode(objectWithValue)
        XCTAssertNil(group)

        group = try? decode(objectWithValue, rootKeyPath: "group")
        XCTAssertNotNil(group)
    }

    func testDecodeWithRootKeyArray() {
        let objectWithArray: JSONDictionary = [ "groups": [ JSON, JSON ] ]

        var groups: [Group]?

        groups = try? decode(objectWithArray)
        XCTAssertNil(groups)

        groups = try? decode(objectWithArray, rootKeyPath: "groups")
        XCTAssertNotNil(groups)
        XCTAssertEqual(groups?.count, 2)
    }

    func testDecodeWithRootKeyDictionary() {
        let objectWithDictionary: JSONDictionary = [ "groupDict": [ "foo": JSON, "bar": JSON ] ]

        var groups: [String: Group]?

        groups = try? decode(objectWithDictionary)
        XCTAssertNil(groups)

        groups = try? decode(objectWithDictionary, rootKeyPath: "groupDict")
        XCTAssertNotNil(groups)
        XCTAssertEqual(groups?.count, 2)
        XCTAssertEqual(groups?.keys.contains("foo"), true)
        XCTAssertEqual(groups?.keys.contains("bar"), true)
    }
}

extension DecodeWithRootKeyPathTest {
    static var allTests: [(String, (DecodeWithRootKeyPathTest) -> () throws -> Void)] {
        return [
            ("testDecodeWithRootKeyValue", testDecodeWithRootKeyValue),
            ("testDecodeWithRootKeyArray", testDecodeWithRootKeyArray),
            ("testDecodeWithRootKeyDictionary", testDecodeWithRootKeyDictionary)
        ]
    }
}
