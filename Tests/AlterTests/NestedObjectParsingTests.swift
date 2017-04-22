//
//  NestedObjectParsingTests.swift
//  JSONTypedDecoder
//
//  Created by 林 達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import XCTest
import JSONTypedDecoder

class NestedObjectParsingTests: XCTestCase {

    func testParseNestedObjectSuccess() {
        let JSON: JSONDictionary = [ "nested": [ "name": "Foo Bar" ] ]
        let success = try? WithNestedObject.decodeValue(JSON)
        XCTAssertNotNil(success)
        XCTAssertEqual(success?.nestedName, "Foo Bar")
    }

    func testParseNestedObjectFailure() {
        let JSON: JSONDictionary = [ "nested": "Foo Bar" ]
        let failure = try? WithNestedObject.decodeValue(JSON)
        XCTAssertNil(failure)
    }
}

extension NestedObjectParsingTests {
    static var allTests: [(String, (NestedObjectParsingTests) -> () throws -> Void)] {
        return [
            ("testParseNestedObjectSuccess", testParseNestedObjectSuccess),
            ("testParseNestedObjectFailure", testParseNestedObjectFailure)
        ]
    }
}

struct WithNestedObject: Decodable {
    let nestedName: String

    static func decode(_ decoder: Decoder) throws -> WithNestedObject {
        return self.init(nestedName: try decoder <| [ "nested", "name" ])
    }
}
