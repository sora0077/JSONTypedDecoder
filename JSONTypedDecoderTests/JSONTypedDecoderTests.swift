//
//  JSONTypedDecoderTests.swift
//  JSONTypedDecoderTests
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import XCTest
@testable import JSONTypedDecoder

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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
