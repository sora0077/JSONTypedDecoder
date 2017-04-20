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
        return try dict.flatMap {
            guard let value = $0 else {
                if allowInvalidElements { return nil }
                throw DecodeError.typeMissmatch(expected: T.self, actual: $0, keyPath: keyPath)
            }
            return value
        }
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
