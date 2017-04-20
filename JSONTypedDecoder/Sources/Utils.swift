//
//  Utils.swift
//  JSONTypedDecoder
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

extension Dictionary {
    func map<T>(_ transform: (Value) throws -> T) rethrows -> [Key: T] {
        var result: [Key: T] = [:]
        for (key, value) in self {
            result[key] = try transform(value)
        }
        return result
    }

    func flatMap<T>(_ transform: (Value) throws -> T?) rethrows -> [Key: T] {
        var result: [Key: T] = [:]
        for (key, value) in self {
            if let v = try transform(value) {
                result[key] = v
            }
        }
        return result
    }
}
