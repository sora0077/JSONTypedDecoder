//
//  Decoder+Dictionary.swift
//  JSONTypedDecoder
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

extension Decoder {
    public func decode<T>(forKeyPath keyPath: KeyPath) throws -> [String: T] where T: Decodable {
        return try decode(forKeyPath: keyPath, allowInvalidElements: false)
    }

    public func decode<T>(forKeyPath keyPath: KeyPath) throws -> [String: T]? where T: Decodable {
        return try decode(forKeyPath: keyPath, allowInvalidElements: false)
    }

    public func decode<T>(forKeyPath keyPath: KeyPath, allowInvalidElements: Bool) throws -> [String: T] where T: Decodable {
        let dict: [String: T?] = try decode(forKeyPath: keyPath)
        var result: [String: T] = [:]
        for (key, value) in dict {
            guard let v = value else {
                if allowInvalidElements { continue }
                throw DecodeError.typeMissmatch(expected: T.self, actual: value, keyPath: keyPath)
            }
            result[key] = v
        }
        return result
    }

    public func decode<T>(forKeyPath keyPath: KeyPath, allowInvalidElements: Bool) throws -> [String: T]? where T: Decodable {
        do {
            return try decode(forKeyPath: keyPath, allowInvalidElements: allowInvalidElements) as [String: T]
        } catch DecodeError.missingKeyPath {
            return nil
        }
    }

    public func decode<T>(forKeyPath keyPath: KeyPath) throws -> [String: T?]? where T: Decodable {
        do {
            return try decode(forKeyPath: keyPath) as [String: T?]
        } catch DecodeError.missingKeyPath {
            return nil
        }
    }
}
