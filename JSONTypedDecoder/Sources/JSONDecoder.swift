//
//  JSONDecoder.swift
//  JSONTypedDecoder
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

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
        guard let v: T = try value(for: keyPath, from: rawValue) else {
            return nil
        }
        do {
            return try T.decode(JSONDecoder(v))
        } catch let DecodeError.typeMissmatch(expected, actual, missmatched) {
            throw DecodeError.typeMissmatch(expected: expected, actual: actual, keyPath: keyPath + missmatched)
        }
    }
    
    func decode<T, R>(forKeyPath keyPath: KeyPath, _ transform: (T) throws -> R) throws -> R? where T : Decodable {
        fatalError()
    }
}

typealias JSONDictionary = [String: Any]
typealias JSONArray = [Any]

private func value<T>(for keyPath: KeyPath, from json: Any) throws -> T? {
    var result: Any? = json
    var reached: [KeyPath.Component] = []
    for key in keyPath {
        reached.append(key)
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
            let expected: Any.Type = {
                switch key {
                case .key: return JSONDictionary.self
                case .index: return JSONArray.self
                }
            }()
            throw DecodeError.typeMissmatch(expected: expected, actual: result, keyPath: KeyPath(components: reached))
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
