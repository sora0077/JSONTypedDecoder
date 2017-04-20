//
//  Decodable.swift
//  JSONTypedDecoder
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

public protocol Decodable {
    static func decode(_ decoder: Decoder) throws -> Self
}

struct Test: Decodable {
    let val: Int
    
    static func decode(_ decoder: Decoder) throws -> Test {
        return try self.init(
            val: decoder.decode(forKeyPath: "val"))
    }
}


func castOrFail<T>(_ decoder: Decoder) throws -> T {
    return try castOrFail(decoder.rawValue)
}

func castOrFail<T>(_ any: Any) throws -> T {
    guard let result = any as? T else {
        throw Error.typeMissmatch(expected: T.self, actual: any, keyPath: .empty)
    }
    return result
}
