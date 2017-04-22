//
//  Utils.swift
//  JSONTypedDecoder
//
//  Created by 林 達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import XCTest
@testable import JSONTypedDecoder

extension String {
    static let `nil`: String? = .none
}

extension JSONDecoder {
    init(_ any: Any) {
        // swiftlint:disable:next force_try
        try! self.init(any, rootKeyPath: .empty)
    }
}

func json(_ object: Any) -> Data {
    // swiftlint:disable:next force_try
    return try! JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
}

func XCTAssertEqual<T, U>(
    _ expression1: @autoclosure () throws -> [T : U?],
    _ expression2: @autoclosure () throws -> [T : U?],
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line)
    where T : Hashable, U : Equatable {
        do {
            let (v1, v2) = try (expression1(), expression2())
            XCTAssertEqual(v1.count, v2.count, message() + " Dictionary.count missmatch.", file: file, line: line)
            let (looper, target) = v1.count > v2.count ? (v1, v2) : (v2, v1)
            for (k, v) in looper {
                XCTAssertEqual(v, target[k] ?? nil, message(), file: file, line: line)
            }
        } catch {
            XCTFail(message() + " \(error)", file: file, line: line)
        }
}

// Himotoki like operator

infix operator <| : MultiplicationPrecedence
infix operator <|? : MultiplicationPrecedence
infix operator <|| : MultiplicationPrecedence
infix operator <||? : MultiplicationPrecedence
infix operator <|-| : MultiplicationPrecedence
infix operator <|-|? : MultiplicationPrecedence

/// - Throws: DecodeError or an arbitrary ErrorType
func <| <T: Decodable>(decoder: Decoder, keyPath: KeyPath) throws -> T {
    return try decoder.decode(forKeyPath: keyPath)
}

/// - Throws: DecodeError or an arbitrary ErrorType
func <| (decoder: Decoder, keyPath: KeyPath) throws -> Any {
    return try decoder.decode(forKeyPath: keyPath)
}

/// - Throws: DecodeError or an arbitrary ErrorType
func <|? <T: Decodable>(decoder: Decoder, keyPath: KeyPath) throws -> T? {
    return try decoder.decode(forKeyPath: keyPath)
}

/// - Throws: DecodeError or an arbitrary ErrorType
func <|| <T: Decodable>(decoder: Decoder, keyPath: KeyPath) throws -> [T] {
    return try decoder.decode(forKeyPath: keyPath)
}

/// - Throws: DecodeError or an arbitrary ErrorType
func <||? <T: Decodable>(decoder: Decoder, keyPath: KeyPath) throws -> [T]? {
    return try decoder.decode(forKeyPath: keyPath)
}

/// - Throws: DecodeError or an arbitrary ErrorType
func <|-| <T: Decodable>(decoder: Decoder, keyPath: KeyPath) throws -> [String: T] {
    return try decoder.decode(forKeyPath: keyPath)
}

/// - Throws: DecodeError or an arbitrary ErrorType
func <|-|? <T: Decodable>(decoder: Decoder, keyPath: KeyPath) throws -> [String: T]? {
    return try decoder.decode(forKeyPath: keyPath)
}
