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

extension Decodable {
    static func _decode(_ decoder: Decoder) throws -> Self {
        return try castOrFail(decoder)
    }

    public static func decode(_ decoder: Decoder) throws -> Self {
        return try _decode(decoder)
    }
}

public protocol PrimitiveDecodable: Decodable {
    init?(_ text: String, radix: Int)

    static func decode(from number: NSNumber) -> Self
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
