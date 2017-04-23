//
//  decode.swift
//  Alter
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

var DecoderClass: Decoder.Type = JSONDecoder.self

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> T where T: Decodable {
    return try T.decode(DecoderClass.init(any, rootKeyPath: rootKeyPath))
}

// MARK: Array
public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> [T?] where T: Decodable {
    let decoder = try DecoderClass.init(any, rootKeyPath: rootKeyPath)
    guard let array = decoder.rawValue as? [Any?] else {
        throw DecodeError.typeMismatch(expected: [T?].self, actual: decoder.rawValue, keyPath: rootKeyPath ?? .empty)
    }
    return try array.map {
        do {
            return try $0.map { try DecoderClass.init($0, rootKeyPath: nil) }.map(T.decode)
        } catch DecodeError.missingKeyPath {
            return nil
        }
    }
}

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil, skipInvalidElements: Bool = false) throws -> [T] where T: Decodable {
    let array: [T?] = try decode(any, rootKeyPath: rootKeyPath)
    return try array.flatMap {
        guard let val = $0 else {
            if skipInvalidElements { return nil }
            throw DecodeError.typeMismatch(expected: T.self, actual: $0, keyPath: rootKeyPath ?? .empty)
        }
        return val
    }
}

// MARK: - Dictionary
public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> [String: T?] where T: Decodable {
    let decoder = try DecoderClass.init(any, rootKeyPath: rootKeyPath ?? .empty)
    guard let dictionary = decoder.rawValue as? [String: Any?] else {
        throw DecodeError.typeMismatch(expected: [String: T?].self, actual: decoder.rawValue, keyPath: rootKeyPath ?? .empty)
    }
    return try dictionary.map {
        try $0.map { try DecoderClass.init($0, rootKeyPath: nil) }.map(T.decode)
    }
}

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil, skipInvalidElements: Bool = false) throws -> [String: T]
    where T: Decodable {
    let dictionary: [String: T?] = try decode(any, rootKeyPath: rootKeyPath)
    return try dictionary.flatMap {
        guard let val = $0 else {
            if skipInvalidElements { return nil }
            throw DecodeError.typeMismatch(expected: T.self, actual: $0, keyPath: rootKeyPath ?? .empty)
        }
        return val
    }
}
