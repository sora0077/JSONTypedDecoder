//
//  JSONTypedDecoderTests.swift
//  JSONTypedDecoderTests
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import XCTest
@testable import JSONTypedDecoder

extension String {
    static let `nil`: String? = .none
}

class JSONTypedDecoderTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let data: Any = [
            ["title": "zero",
             "int": 0],
            ["title": "one",
             "int": 1]
            ] as [[String: Any]]
        let decoder = JSONDecoder(data)
        XCTAssertEqual(try decoder.decode(forKeyPath: [1, "title"]), "one")
        XCTAssertEqual(try decoder.decode(forKeyPath: [0, "int"]), 0)
    }

    func testMissing() {
        let data: Any = [
            ["title": "zero",
             "int": 0],
            ["int": 1]
            ] as [[String: Any]]
        let decoder = JSONDecoder(data)
        let keyPath: KeyPath = [1, "title"]
        do {
            let _: String = try decoder.decode(forKeyPath: keyPath)
            XCTFail()
        } catch DecodeError.missingKeyPath(let missing) {
            XCTAssertEqual(missing, keyPath)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testMissingInMidFlow() {
        let data: Any = [
            ["int": 0],
            ["int": 1]
            ] as [[String: Any]]
        let decoder = JSONDecoder(data)
        let keyPath: KeyPath = [1, "title", "val"]
        do {
            let _: String = try decoder.decode(forKeyPath: keyPath)
            XCTFail()
        } catch DecodeError.missingKeyPath(let missing) {
            XCTAssertEqual(missing, [1, "title"])
        } catch {
            XCTFail("\(error)")
        }
    }

    func testMissingInMidFlowWithOptional() {
        let data: Any = [
            ["int": 0],
            ["int": 1]
            ] as [[String: Any]]
        let decoder = JSONDecoder(data)
        let keyPath: KeyPath = [1, "title", "val"]
        XCTAssertEqual(try decoder.decode(forKeyPath: keyPath), String.nil)
    }

    func testTypeMissmatched() {
        let data: Any = [
            ["title": 0]
            ] as [[String: Any]]
        let decoder = JSONDecoder(data)
        let keyPath: KeyPath = [0, "title"]
        do {
            let _: String = try decoder.decode(forKeyPath: keyPath)
            XCTFail()
        } catch let DecodeError.typeMissmatch(expected, actual, missmatched) {
            XCTAssertEqual("\(expected)", "\(String.self)")
            XCTAssertEqual(actual as? Int, 0)
            XCTAssertEqual(missmatched, keyPath)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testTypeMissmatchedInMidFlow() {
        let data: Any = [
            ["title": 0]
            ] as [[String: Any]]
        let decoder = JSONDecoder(data)
        let keyPath: KeyPath = [0, "title", "val", "notReached"]
        do {
            let _: String = try decoder.decode(forKeyPath: keyPath)
            XCTFail()
        } catch let DecodeError.typeMissmatch(expected, actual, missmatched) {
            XCTAssertEqual("\(expected)", "\([String: Any].self)")
            XCTAssertEqual(actual as? Int, 0)
            XCTAssertEqual(missmatched, [0, "title", "val"])
        } catch {
            XCTFail("\(error)")
        }
    }

    func testArray() {
        let data: Any = [
            "array": [1, 2, 3]
        ]
        let decoder = JSONDecoder(data)
        let keyPath: KeyPath = "array"
        XCTAssertEqual(try decoder.decode(forKeyPath: keyPath), [1, 2, 3])
    }

    func testArrayWithOptionalSafe() {
        let data: Any = [
            "array": [1, nil, 3]
        ]
        let decoder = JSONDecoder(data)
        let keyPath: KeyPath = "array"
        XCTAssertEqual(try decoder.decode(forKeyPath: keyPath, allowInvalidElements: true), [1, 3])
    }

    func testArrayWithOptional() {
        let data: Any = [
            "array": [1, nil, 3]
        ]
        let decoder = JSONDecoder(data)
        let keyPath: KeyPath = "array"
        do {
            let _: [Int] = try decoder.decode(forKeyPath: keyPath)
            XCTFail()
        } catch let DecodeError.typeMissmatch(expected, actual, missmatched) {
            XCTAssertEqual("\(expected)", "\(Int.self)")
            XCTAssert(actual == nil)
            XCTAssertEqual(missmatched, keyPath)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testDictionary() {
        let data: Any = [
            "dictionary": [
                "a": 1, "b": 2, "c": 3
            ]
        ]
        let decoder = JSONDecoder(data)
        let keyPath: KeyPath = "dictionary"
        XCTAssertEqual(try decoder.decode(forKeyPath: keyPath), ["a": 1, "b": 2, "c": 3])
    }

    func testDictionaryWithOptionalSafe() {
        let data: Any = [
            "dictionary": [
                "a": 1, "b": nil, "c": 3
            ]
        ]
        let decoder = JSONDecoder(data)
        let keyPath: KeyPath = "dictionary"
        XCTAssertEqual(try decoder.decode(forKeyPath: keyPath, allowInvalidElements: true), ["a": 1, "c": 3])
    }

    func testDictionaryWithOptional() {
        let data: Any = [
            "dictionary": [
                "a": 1, "b": nil, "c": 3
            ]
        ]
        let decoder = JSONDecoder(data)
        let keyPath: KeyPath = "dictionary"
        do {
            let _: [String: Int] = try decoder.decode(forKeyPath: keyPath)
            XCTFail()
        } catch let DecodeError.typeMissmatch(expected, actual, missmatched) {
            XCTAssertEqual("\(expected)", "\(Int.self)")
            XCTAssert(actual == nil)
            XCTAssertEqual(missmatched, keyPath)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
