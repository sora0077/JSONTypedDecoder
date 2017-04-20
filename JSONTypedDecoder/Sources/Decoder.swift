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
    func decode<T>(forKeyPath keyPath: KeyPath) throws -> [T?] where T: Decodable
    func decode<T>(forKeyPath keyPath: KeyPath) throws -> [String: T?] where T: Decodable
}

extension Decoder {
    public func decode<T>(forKeyPath keyPath: KeyPath) throws -> T? where T: Decodable {
        do {
            return try decode(forKeyPath: keyPath) as T
        } catch DecodeError.missingKeyPath {
            return nil
        }
    }

    // MARK: array
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

    // MARK: dictionary
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

extension Decoder {
    public func decode<T, R>(forKeyPath keyPath: KeyPath, _ transform: (T) throws -> R) throws -> R where T : Decodable {
        let value: T = try decode(forKeyPath: keyPath)
        do {
            return try transform(value)
        } catch {
            throw DecodeError.transformFailure(error, keyPath: keyPath)
        }
    }

    public func decode<T, R>(forKeyPath keyPath: KeyPath, _ transform: (T) throws -> R) throws -> R? where T : Decodable {
        let value: T? = try decode(forKeyPath: keyPath)
        do {
            return try value.map(transform)
        } catch {
            throw DecodeError.transformFailure(error, keyPath: keyPath)
        }
    }

    public func decode<T, R>(forKeyPath keyPath: KeyPath, transform: (T) throws -> R) throws -> [R] where T: Decodable {
        return try decode(forKeyPath: keyPath, allowInvalidElements: false, transform: transform)
    }

    public func decode<T, R>(forKeyPath keyPath: KeyPath, transform: (T) throws -> R) throws -> [R]? where T: Decodable {
        return try decode(forKeyPath: keyPath, allowInvalidElements: false, transform: transform)
    }

    public func decode<T, R>(forKeyPath keyPath: KeyPath, allowInvalidElements: Bool, transform: (T) throws -> R) throws -> [R] where T: Decodable {
        let value: [T] = try decode(forKeyPath: keyPath, allowInvalidElements: allowInvalidElements)
        return try value.flatMap {
            do {
                return try transform($0)
            } catch {
                throw DecodeError.transformFailure(error, keyPath: keyPath)
            }
        }
    }

    public func decode<T, R>(forKeyPath keyPath: KeyPath, allowInvalidElements: Bool, transform: (T) throws -> R) throws -> [R]? where T: Decodable {
        let value: [T]? = try decode(forKeyPath: keyPath, allowInvalidElements: allowInvalidElements)
        return try value?.flatMap {
            do {
                return try transform($0)
            } catch {
                throw DecodeError.transformFailure(error, keyPath: keyPath)
            }
        }
    }

    public func decode<T, R>(forKeyPath keyPath: KeyPath, transform: (T) throws -> R) throws -> [R?] where T: Decodable {
        let value: [T?] = try decode(forKeyPath: keyPath)
        return try value.map {
            do {
                return try $0.map(transform)
            } catch {
                throw DecodeError.transformFailure(error, keyPath: keyPath)
            }
        }
    }

    public func decode<T, R>(forKeyPath keyPath: KeyPath, transform: (T) throws -> R) throws -> [R?]? where T: Decodable {
        let value: [T?]? = try decode(forKeyPath: keyPath)
        return try value?.flatMap {
            do {
                return try $0.map(transform)
            } catch {
                throw DecodeError.transformFailure(error, keyPath: keyPath)
            }
        }
    }
}
