//
//  JSONDecoder.swift
//  JSONTypedDecoder
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

private typealias JSONDictionary = [String: Any]
private typealias JSONArray = [Any]

func optional<T>(_ value: @autoclosure () throws -> T?, if cond: (Error) -> Bool) rethrows -> T? {
    do {
        return try value()
    } catch let error where cond(error) {
        return nil
    }
}

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
    
    fileprivate func optionalValue<T>(forKeyPath keyPath: KeyPath) throws -> T? {
        return try optional(value(for: keyPath, from: rawValue), if: { (error) in
            switch error {
            case DecodeError.missingKeyPath(let missing) where keyPath == missing: return true
            default: return false
            }
        })
    }
}

/// decode for value
extension JSONDecoder {
    private func _decode<T>(forKeyPath keyPath: KeyPath) throws -> T? where T: Decodable {
        guard let v: T = try optionalValue(forKeyPath: keyPath) else {
            return nil
        }
        do {
            return try T.decode(JSONDecoder(v))
        } catch let DecodeError.typeMissmatch(expected, actual, missmatched) {
            throw DecodeError.typeMissmatch(expected: expected, actual: actual, keyPath: keyPath + missmatched)
        }
    }
    
    func decode<T>(forKeyPath keyPath: KeyPath) throws -> T where T: Decodable {
        guard let value: T = try _decode(forKeyPath: keyPath) else {
            throw DecodeError.missingKeyPath(keyPath)
        }
        return value
    }
    
    func decode<T, R>(forKeyPath keyPath: KeyPath, _ transform: (T) throws -> R) throws -> R where T : Decodable {
        let value: T = try decode(forKeyPath: keyPath)
        do {
            return try transform(value)
        } catch {
            throw DecodeError.transformFailure(error, keyPath: keyPath)
        }
    }
    
    // MARK: - Optional
    func decode<T>(forKeyPath keyPath: KeyPath) throws -> T? where T: Decodable {
        do {
            return try _decode(forKeyPath: keyPath)
        } catch DecodeError.missingKeyPath {
            return nil
        }
    }
    
    func decode<T, R>(forKeyPath keyPath: KeyPath, _ transform: (T) throws -> R) throws -> R? where T : Decodable {
        fatalError()
    }
}

extension JSONDecoder {
    private func _decode<T>(forKeyPath keyPath: KeyPath) throws -> [T?]? where T: Decodable {
        guard let array: [Any?] = try optionalValue(forKeyPath: keyPath) else {
            return nil
        }
        do {
            return try array.map {
                guard let v = $0 else { return nil }
                return try T.decode(JSONDecoder(v))
            }
        } catch let DecodeError.typeMissmatch(expected, actual, missmatched) {
            throw DecodeError.typeMissmatch(expected: expected, actual: actual, keyPath: keyPath + missmatched)
        }
    }
    
    func decode<T>(forKeyPath keyPath: KeyPath, allowInvalidFragments: Bool) throws -> [T] where T: Decodable {
        guard let array: [T?] = try _decode(forKeyPath: keyPath) else {
            throw DecodeError.missingKeyPath(keyPath)
        }
        return try array.flatMap {
            guard let val = $0 else {
                if allowInvalidFragments { return nil }
                throw DecodeError.typeMissmatch(expected: T.self, actual: $0, keyPath: keyPath)
            }
            return val
        }
    }
    
    func decode<T>(forKeyPath keyPath: KeyPath) throws -> [T?] where T: Decodable {
        fatalError()
    }
}


// MARK: - util
private func value<T>(for keyPath: KeyPath, from json: Any) throws -> T? {
    var result: Any? = json
    var reached: [KeyPath.Component] = []
    for key in keyPath {
        defer { reached.append(key) }
        switch (result, key) {
        case (let dict as JSONDictionary, .key(let key)):
            result = dict[key]
        case (let array as JSONArray, .index(let index)) where array.indices.contains(index):
            result = array[index]
        case (is JSONDictionary, .index):
            throw DecodeError.typeMissmatch(expected: JSONArray.self, actual: result, keyPath: keyPath)
        case (is JSONArray, .key):
            throw DecodeError.typeMissmatch(expected: JSONDictionary.self, actual: result, keyPath: keyPath)
        case _ where !(result is T):
            if result == nil {
                print(key)
                throw DecodeError.missingKeyPath(KeyPath(components: reached))
            }
            let expected: Any.Type = {
                switch key {
                case .key: return JSONDictionary.self
                case .index: return JSONArray.self
                }
            }()
            throw DecodeError.typeMissmatch(expected: expected, actual: result, keyPath: KeyPath(components: reached + [key]))
        default: break
        }
    }
    if result is NSNull {
        return nil
    }
    guard let value = result as? T? else {
        throw DecodeError.typeMissmatch(expected: T.self, actual: result, keyPath: keyPath)
    }
    return value
}
