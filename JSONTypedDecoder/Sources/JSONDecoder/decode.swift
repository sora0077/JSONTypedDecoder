//
//  decode.swift
//  JSONTypedDecoder
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

typealias DecoderImpl = JSONDecoder

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> T where T: Decodable {
    return try T.decode(JSONDecoder(any, rootKeyPath: rootKeyPath ?? .empty))
}

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> T? where T: Decodable {
    do {
        return try decode(any, rootKeyPath: rootKeyPath) as T
    } catch DecodeError.missingKeyPath {
        return nil
    }
}

// MARK: Array
public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> [T?] where T: Decodable {
    let decoder = try JSONDecoder(any, rootKeyPath: rootKeyPath ?? .empty)
    return try decoder.array().map {
        do {
            return try T.decode(JSONDecoder($0, rootKeyPath: .empty))
        } catch DecodeError.missingKeyPath {
            return nil
        }
    }
}

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil, allowInvalidElements: Bool = false) throws -> [T] where T: Decodable {
    let array: [T?] = try decode(any, rootKeyPath: rootKeyPath)
    return try array.flatMap {
        guard let val = $0 else {
            if allowInvalidElements { return nil }
            throw DecodeError.typeMismatch(expected: T.self, actual: $0, keyPath: rootKeyPath ?? .empty)
        }
        return val
    }
}

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> [T?]? where T: Decodable {
    do {
        return try decode(any, rootKeyPath: rootKeyPath) as [T?]
    } catch DecodeError.missingKeyPath {
        return nil
    }
}

// MARK: - Dictionary
public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> [String: T?] where T: Decodable {
    let decoder = try JSONDecoder(any, rootKeyPath: rootKeyPath ?? .empty)
    return try decoder.dictionary().map {
        try T.decode(JSONDecoder($0, rootKeyPath: .empty))
    }
}

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil, allowInvalidElements: Bool = false) throws -> [String: T]
    where T: Decodable {
    let dictionary: [String: T?] = try decode(any, rootKeyPath: rootKeyPath)
    return try dictionary.flatMap {
        guard let val = $0 else {
            if allowInvalidElements { return nil }
            throw DecodeError.typeMismatch(expected: T.self, actual: $0, keyPath: rootKeyPath ?? .empty)
        }
        return val
    }
}

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> [String: T?]? where T: Decodable {
    do {
        return try decode(any, rootKeyPath: rootKeyPath) as [String: T?]
    } catch DecodeError.missingKeyPath {
        return nil
    }
}
