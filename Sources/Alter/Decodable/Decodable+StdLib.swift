//
//  Decodable+StdLib.swift
//  Alter
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

public protocol PrimitiveDecodable: Decodable {}

extension PrimitiveDecodable {
    public static func decode(_ decoder: Decoder) throws -> Self {
        return try castOrFail(decoder)
    }
}

extension String: PrimitiveDecodable {}

extension Int: PrimitiveDecodable {}

extension UInt: PrimitiveDecodable {}

extension Double: PrimitiveDecodable {}

extension Float: PrimitiveDecodable {}

extension Bool: PrimitiveDecodable {}
