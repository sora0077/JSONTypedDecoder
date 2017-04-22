//
//  Decodable+NSNumber.swift
//  Alter
//
//  Created by 林 達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

extension NSNumber: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Self {
        return try castOrFail(decoder)
    }
}

extension Int8: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Int8 {
        return try NSNumber.decode(decoder).int8Value
    }
}

extension UInt8: Decodable {
    public static func decode(_ decoder: Decoder) throws -> UInt8 {
        return try NSNumber.decode(decoder).uint8Value
    }
}

extension Int16: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Int16 {
        return try NSNumber.decode(decoder).int16Value
    }
}

extension UInt16: Decodable {
    public static func decode(_ decoder: Decoder) throws -> UInt16 {
        return try NSNumber.decode(decoder).uint16Value
    }
}

extension Int32: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Int32 {
        return try NSNumber.decode(decoder).int32Value
    }
}

extension UInt32: Decodable {
    public static func decode(_ decoder: Decoder) throws -> UInt32 {
        return try NSNumber.decode(decoder).uint32Value
    }
}

extension Int64: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Int64 {
        return try NSNumber.decode(decoder).int64Value
    }
}

extension UInt64: Decodable {
    public static func decode(_ decoder: Decoder) throws -> UInt64 {
        return try NSNumber.decode(decoder).uint64Value
    }
}
