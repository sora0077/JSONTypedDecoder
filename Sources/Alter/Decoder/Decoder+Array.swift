//
//  Decoder+Array.swift
//  Alter
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

extension Decoder {
    public func decode<T>(forKeyPath keyPath: KeyPath, skipInvalidElements: Bool = false) throws -> [T] where T: Decodable {
        return try (decode(forKeyPath: keyPath) as [T?]).flatMap {
            guard let val = $0 else {
                if skipInvalidElements { return nil }
                throw DecodeError.typeMismatch(expected: T.self, actual: $0, keyPath: keyPath)
            }
            return val
        }
    }

    public func decode<T>(forKeyPath keyPath: KeyPath, optional: Bool) throws -> [T]? where T: Decodable {
        do {
            return try decode(forKeyPath: keyPath, skipInvalidElements: false)
        } catch DecodeError.missingKeyPath(let missing) where optional && checkOptional(missing: missing, for: keyPath) {
            return nil
        }
    }
}
