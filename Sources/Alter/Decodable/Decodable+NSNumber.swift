//
//  Decodable+NSNumber.swift
//  Alter
//
//  Created by 林 達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

extension PrimitiveDecodable {
//    #if !os(Linux)
    public static func decode(_ decoder: Decoder) throws -> Self {
        return try decode(from: NSNumber.decode(decoder))
    }
//    #else
//    public static func decode(_ decoder: Decoder) throws -> Self {
//        guard let value = self.init("\(decoder.rawValue)", radix: 10) else {
//            throw DecodeError.typeMismatch(expected: self, actual: decoder.rawValue, keyPath: .empty)
//        }
//        return value
//    }
//    #endif
}

extension NSNumber: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Self {
        #if !os(Linux)
            return try _decode(decoder)
        #else
            return try castOrFail(decoder)
        #endif
    }
}

extension Int8: PrimitiveDecodable {
    public static func decode(from number: NSNumber) -> Int8 {
        return number.int8Value
    }
}

extension UInt8: PrimitiveDecodable {
    public static func decode(from number: NSNumber) -> UInt8 {
        return number.uint8Value
    }
}

extension Int16: PrimitiveDecodable {
    public static func decode(from number: NSNumber) -> Int16 {
        return number.int16Value
    }
}

extension UInt16: PrimitiveDecodable {
    public static func decode(from number: NSNumber) -> UInt16 {
        return number.uint16Value
    }
}

extension Int32: PrimitiveDecodable {
    public static func decode(from number: NSNumber) -> Int32 {
        return number.int32Value
    }
}

extension UInt32: PrimitiveDecodable {
    public static func decode(from number: NSNumber) -> UInt32 {
        return number.uint32Value
    }
}

extension Int64: PrimitiveDecodable {
    public static func decode(from number: NSNumber) -> Int64 {
        return number.int64Value
    }
}

extension UInt64: PrimitiveDecodable {
    public static func decode(from number: NSNumber) -> UInt64 {
        return number.uint64Value
    }
}
