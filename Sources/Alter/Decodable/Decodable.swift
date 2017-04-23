//
//  Decodable.swift
//  Alter
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

public protocol Decodable {
    static func decode(_ decoder: Decoder) throws -> Self
}

public protocol PrimitiveDecodable: Decodable {}

extension PrimitiveDecodable {
    public static func decode(_ decoder: Decoder) throws -> Self {
        return try _decode(decoder)
    }

    static func _decode(_ decoder: Decoder) throws -> Self {
        return try castOrFail(decoder)
    }
}

#if !os(Linux)
    private func castOrFail<T>(_ decoder: Decoder) throws -> T {
        return try castOrFail(decoder.rawValue)
    }
#else
    func castOrFail<T>(_ decoder: Decoder) throws -> T {
        return try castOrFail(decoder.rawValue)
    }
#endif

private func castOrFail<T>(_ any: Any) throws -> T {
    guard let result = any as? T else {
        throw DecodeError.typeMismatch(expected: T.self, actual: any, keyPath: .empty)
    }
    return result
}
