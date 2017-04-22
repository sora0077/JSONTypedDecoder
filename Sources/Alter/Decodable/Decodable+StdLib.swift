//
//  Decodable+StdLib.swift
//  Alter
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

extension String: Decodable {
    public static func decode(_ decoder: Decoder) throws -> String {
        return try castOrFail(decoder)
    }
}

extension Int: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Int {
        return try castOrFail(decoder)
    }
}

extension UInt: Decodable {
    public static func decode(_ decoder: Decoder) throws -> UInt {
        return try castOrFail(decoder)
    }
}

extension Double: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Double {
        return try castOrFail(decoder)
    }
}

extension Float: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Float {
        return try castOrFail(decoder)
    }
}

extension Bool: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Bool {
        return try castOrFail(decoder)
    }
}
