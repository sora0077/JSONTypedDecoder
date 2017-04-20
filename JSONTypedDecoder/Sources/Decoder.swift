//
//  Decoder.swift
//  JSONTypedDecoder
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

public protocol Decoder {
    var rawValue: Any { get }
    func decode<T>(forKeyPath keyPath: KeyPath) throws -> T where T: Decodable
    func decode<T, R>(forKeyPath keyPath: KeyPath, _ transform: (T) throws -> R) throws -> R where T: Decodable
    // Optional
    func decode<T>(forKeyPath keyPath: KeyPath) throws -> T? where T: Decodable
    func decode<T, R>(forKeyPath keyPath: KeyPath, _ transform: (T) throws -> R) throws -> R? where T: Decodable
}

extension Decoder {
    public func decode<T>(forKeyPath keyPath: KeyPath) throws -> T where T: Decodable {
        guard let value: T = try decode(forKeyPath: keyPath) else {
            throw Error.missingKeyPath(keyPath)
        }
        return value
    }
    
    public func decode<T, R>(forKeyPath keyPath: KeyPath, _ transform: (T) throws -> R) throws -> R where T : Decodable {
        let value: T = try decode(forKeyPath: keyPath)
        do {
            return try transform(value)
        } catch {
            throw Error.transformFailure(error, keyPath: keyPath)
        }
    }
}

// MARK: - JSONDecoder
struct JSONDecoder: Decoder {
    var rawValue: Any { return data.rawValue }
    private let data: Data
    fileprivate enum Data {
        case dictionary(JSONDictionary)
        case array(JSONArray)
        case value(Any)
        
        var rawValue: Any {
            switch self {
            case .dictionary(let dictionary): return dictionary
            case .array(let array): return array
            case .value(let value): return value
            }
        }
    }
    
    init(dictionary: [String: Any]) {
        data = .dictionary(dictionary)
    }
    init(array: [Any]) {
        data = .array(array)
    }
    private init(value: Any) {
        data = .value(value)
    }
    init(_ any: Any) {
        switch any {
        case let dictionary as JSONDictionary:
            self.init(dictionary: dictionary)
        case let array as JSONArray:
            self.init(array: array)
        default:
            self.init(value: any)
        }
    }
    
    // MARK: - Optional
    func decode<T>(forKeyPath keyPath: KeyPath) throws -> T? where T: Decodable {
        guard let v = try value(for: keyPath, from: rawValue) else {
            return nil
        }
        do {
            return try T.decode(JSONDecoder(v))
        } catch let Error.typeMissmatch(expected, actual, missmatched) {
            throw Error.typeMissmatch(expected: expected, actual: actual, keyPath: keyPath + missmatched)
        }
    }
    
    func decode<T, R>(forKeyPath keyPath: KeyPath, _ transform: (T) throws -> R) throws -> R? where T : Decodable {
        fatalError()
    }
}

typealias JSONDictionary = [String: Any]
typealias JSONArray = [Any]

private func value(for keyPath: KeyPath, from json: Any) throws -> Any? {
    var result = json
    for key in keyPath {
        switch (result, key) {
        case (let dict as JSONDictionary, .key(let key)) where dict.keys.contains(key):
            result = dict[key]!
        case (let array as JSONArray, .index(let index)) where array.indices.contains(index):
            result = array[index]
        case (is JSONDictionary, .index):
            throw Error.typeMissmatch(expected: JSONArray.self, actual: result, keyPath: keyPath)
        case (is JSONArray, .key):
            throw Error.typeMissmatch(expected: JSONDictionary.self, actual: result, keyPath: keyPath)
        default:
            return nil
        }
    }
    if result is NSNull {
        return nil
    }
    return result
}
