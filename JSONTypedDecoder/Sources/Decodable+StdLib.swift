//
//  Decodable+StdLib.swift
//  JSONTypedDecoder
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

extension Int: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Int {
        return try castOrFail(decoder)
    }
}

extension String: Decodable {
    public static func decode(_ decoder: Decoder) throws -> String {
        return try castOrFail(decoder)
    }
}
