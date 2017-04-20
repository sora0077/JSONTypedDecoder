//
//  Decoder+Array.swift
//  JSONTypedDecoder
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

extension Decoder {
    public func decode<T>(forKeyPath keyPath: KeyPath) throws -> [T] where T: Decodable {
        return try decode(forKeyPath: keyPath, allowInvalidElements: false)
    }

    public func decode<T>(forKeyPath keyPath: KeyPath) throws -> [T]? where T: Decodable {
        return try decode(forKeyPath: keyPath, allowInvalidElements: false)
    }

    public func decode<T>(forKeyPath keyPath: KeyPath, allowInvalidElements: Bool) throws -> [T] where T: Decodable {
        return try (decode(forKeyPath: keyPath) as [T?]).flatMap {
            guard let val = $0 else {
                if allowInvalidElements { return nil }
                throw DecodeError.typeMissmatch(expected: T.self, actual: $0, keyPath: keyPath)
            }
            return val
        }
    }

    public func decode<T>(forKeyPath keyPath: KeyPath, allowInvalidElements: Bool) throws -> [T]? where T : Decodable {
        do {
            return try decode(forKeyPath: keyPath, allowInvalidElements: allowInvalidElements) as [T]
        } catch DecodeError.missingKeyPath {
            return nil
        }
    }

    public func decode<T>(forKeyPath keyPath: KeyPath) throws -> [T?]? where T : Decodable {
        do {
            return try decode(forKeyPath: keyPath) as [T?]
        } catch DecodeError.missingKeyPath {
            return nil
        }
    }
}
