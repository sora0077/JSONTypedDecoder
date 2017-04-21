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

struct JSONDecoder: Decoder {
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
    var rawValue: Any { return data.rawValue }
    private let data: Data
    fileprivate init(_ any: Any) {
        switch any {
        case let dictionary as JSONDictionary:
            data = .dictionary(dictionary)
        case let array as JSONArray:
            data = .array(array)
        default:
            data = .value(any)
        }
    }
    init(_ any: Any, rootKeyPath: KeyPath) throws {
        switch any {
        case let data as Foundation.Data:
            try self.init(JSONSerialization.jsonObject(with: data, options: .allowFragments), rootKeyPath: rootKeyPath)
        case _ where rootKeyPath.isEmpty:
            self.init(any)
        case _:
            guard let v = try value(for: rootKeyPath, from: any) else {
                throw DecodeError.missingKeyPath(rootKeyPath)
            }
            self.init(v)
        }
    }

    func array() throws -> [Any] {
        switch data {
        case .array(let array):
            return array
        default:
            throw DecodeError.typeMismatch(expected: JSONArray.self, actual: rawValue, keyPath: .empty)
        }
    }

    func dictionary() throws -> [String: Any] {
        switch data {
        case .dictionary(let dictionary):
            return dictionary
        default:
            throw DecodeError.typeMismatch(expected: JSONDictionary.self, actual: rawValue, keyPath: .empty)
        }
    }

    fileprivate func optionalValue(forKeyPath keyPath: KeyPath) throws -> Any? {
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
        guard let v = try optionalValue(forKeyPath: keyPath) else {
            return nil
        }
        do {
            return try T.decode(JSONDecoder(v))
        } catch let DecodeError.typeMismatch(expected, actual, missmatched) {
            throw DecodeError.typeMismatch(expected: expected, actual: actual, keyPath: keyPath + missmatched)
        }
    }

    func decode<T>(forKeyPath keyPath: KeyPath) throws -> T where T: Decodable {
        guard let value: T = try _decode(forKeyPath: keyPath) else {
            throw DecodeError.missingKeyPath(keyPath)
        }
        return value
    }
}

/// decode for array
extension JSONDecoder {
    private func _decode<T>(forKeyPath keyPath: KeyPath) throws -> [T?]? where T: Decodable {
        guard let array = try optionalValue(forKeyPath: keyPath) as? [Any?] else {
            return nil
        }
        do {
            return try array.map {
                guard let v = $0 else { return nil }
                return try T.decode(JSONDecoder(v))
            }
        } catch let DecodeError.typeMismatch(expected, actual, missmatched) {
            throw DecodeError.typeMismatch(expected: expected, actual: actual, keyPath: keyPath + missmatched)
        }
    }

    func decode<T>(forKeyPath keyPath: KeyPath) throws -> [T?] where T: Decodable {
        guard let array: [T?] = try _decode(forKeyPath: keyPath) else {
            throw DecodeError.missingKeyPath(keyPath)
        }
        return array
    }
}

/// decode for dictionary
extension JSONDecoder {
    private func _decode<T>(forKeyPath keyPath: KeyPath) throws -> [String: T?]? where T: Decodable {
        guard let dictionary = try optionalValue(forKeyPath: keyPath) as? [String: Any?] else {
            return nil
        }
        do {
            return try dictionary.map {
                try $0.map(JSONDecoder.init).map(T.decode)
            }
        } catch let DecodeError.typeMismatch(expected, actual, missmatched) {
            throw DecodeError.typeMismatch(expected: expected, actual: actual, keyPath: keyPath + missmatched)
        }
    }

    func decode<T>(forKeyPath keyPath: KeyPath) throws -> [String : T?] where T : Decodable {
        guard let dictionary: [String: T?] = try _decode(forKeyPath: keyPath) else {
            throw DecodeError.missingKeyPath(keyPath)
        }
        return dictionary
    }
}

// MARK: - util
private extension KeyPath.Component {
    var expectedType: Any.Type {
        switch self {
        case .key: return JSONDictionary.self
        case .index: return JSONArray.self
        }
    }
}

private func value(for keyPath: KeyPath, from json: Any) throws -> Any? {  // swiftlint:disable:this cyclomatic_complexity
    var result: Any? = json
    var reached: [KeyPath.Component] = []
    for key in keyPath {
        defer { reached.append(key) }
        switch (result, key) {
        case (let dict as JSONDictionary, .key(let key)):
            result = dict[key]
        case (let array as JSONArray, .index(let index)):
            result = array.indices.contains(index) ? array[index] : nil
        case (is JSONDictionary, .index):
            throw DecodeError.typeMismatch(expected: JSONArray.self, actual: result, keyPath: keyPath)
        case (is JSONArray, .key):
            throw DecodeError.typeMismatch(expected: JSONDictionary.self, actual: result, keyPath: keyPath)
        case (nil, _):
            throw DecodeError.missingKeyPath(KeyPath(components: reached))
        default:
            throw DecodeError.typeMismatch(expected: key.expectedType, actual: result, keyPath: KeyPath(components: reached + [key]))
        }
    }
    switch result {
    case is NSNull, nil:
        return nil
    case let value?:
        return value
    }
}
