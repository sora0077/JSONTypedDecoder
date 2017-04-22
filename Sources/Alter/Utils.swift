//
//  Utils.swift
//  Alter
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

extension Dictionary {
    func map<T>(_ transform: (Value) throws -> T) rethrows -> [Key: T] {
        return try flatMap(transform)
    }

    func flatMap<T>(_ transform: (Value) throws -> T?) rethrows -> [Key: T] {
        var result = [Key: T](minimumCapacity: count)
        for (key, value) in self {
            if let v = try transform(value) {
                result[key] = v
            }
        }
        return result
    }
}

func optional<T>(_ value: @autoclosure () throws -> T?, if cond: (Error) -> Bool) rethrows -> T? {
    do {
        return try value()
    } catch let error where cond(error) {
        return nil
    }
}
