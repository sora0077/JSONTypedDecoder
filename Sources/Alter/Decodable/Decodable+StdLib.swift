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
        return try _decode(decoder)
    }
}

extension Bool: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Bool {
        return try _decode(decoder)
    }
}

extension Int: PrimitiveDecodable {
    public static func decode(_ decoder: Decoder) throws -> Int {
        do {
            return try _decode(decoder)
        } catch let error {
            do {
                return try NSNumber.decode(decoder).intValue
            } catch _ {
                throw error
            }
        }
    }

    public static func decode(from number: NSNumber) -> Int {
        return number.intValue
    }
}

extension UInt: PrimitiveDecodable {
    public static func decode(_ decoder: Decoder) throws -> UInt {
        do {
            return try _decode(decoder)
        } catch let error {
            do {
                return try NSNumber.decode(decoder).uintValue
            } catch _ {
                throw error
            }
        }
    }

    public static func decode(from number: NSNumber) -> UInt {
        return number.uintValue
    }
}

extension Double: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Double {
        do {
            return try _decode(decoder)
        } catch let error {
            do {
                return try NSNumber.decode(decoder).doubleValue
            } catch _ {
                throw error
            }
        }
    }
}

extension Float: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Float {
        do {
            return try _decode(decoder)
        } catch let error {
            do {
                return try NSNumber.decode(decoder).floatValue
            } catch _ {
                throw error
            }
        }
    }
}
