//
//  Decodable+NSNumber.swift
//  Alter
//
//  Created by 林 達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

#if os(Linux)
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
#endif

extension NSNumber: PrimitiveDecodable {
    #if os(Linux)
    private static func conv<T>(linux number: NSNumber) -> T {
        return number as! T  // swiftlint:disable:this force_cast
    }
    #endif

    public static func decode(_ decoder: Decoder) throws -> Self {
        #if !os(Linux)
            return try _decode(decoder)
        #else
            guard let number = formatter.number(from: "\(decoder.rawValue)") else {
                throw DecodeError.typeMismatch(expected: self, actual: decoder.rawValue, keyPath: .empty)
            }
            return conv(linux: number)
        #endif
    }
}

extension Int8: PrimitiveDecodable {
    public static func decode(_ decoder: Decoder) throws -> Int8 {
        return try NSNumber.decode(decoder).int8Value
    }
}

extension UInt8: PrimitiveDecodable {
    public static func decode(_ decoder: Decoder) throws -> UInt8 {
        return try NSNumber.decode(decoder).uint8Value
    }
}

extension Int16: PrimitiveDecodable {
    public static func decode(_ decoder: Decoder) throws -> Int16 {
        return try NSNumber.decode(decoder).int16Value
    }
}

extension UInt16: PrimitiveDecodable {
    public static func decode(_ decoder: Decoder) throws -> UInt16 {
        return try NSNumber.decode(decoder).uint16Value
    }
}

extension Int32: PrimitiveDecodable {
    public static func decode(_ decoder: Decoder) throws -> Int32 {
        return try NSNumber.decode(decoder).int32Value
    }
}

extension UInt32: PrimitiveDecodable {
    public static func decode(_ decoder: Decoder) throws -> UInt32 {
        return try NSNumber.decode(decoder).uint32Value
    }
}

extension Int64: PrimitiveDecodable {
    public static func decode(_ decoder: Decoder) throws -> Int64 {
        return try NSNumber.decode(decoder).int64Value
    }
}

extension UInt64: PrimitiveDecodable {
    public static func decode(_ decoder: Decoder) throws -> UInt64 {
        #if os(Linux)
            guard let int = UInt64("\(decoder.rawValue)", radix: 10) else {
                throw DecodeError.typeMismatch(expected: UInt64.self, actual: decoder.rawValue, keyPath: .empty)
            }
            return int
        #else
            return try NSNumber.decode(decoder).uint64Value
        #endif
    }
}
