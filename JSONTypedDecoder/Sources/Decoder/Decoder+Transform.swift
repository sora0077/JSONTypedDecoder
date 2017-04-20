//
//  Decoder+Transform.swift
//  JSONTypedDecoder
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

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
}

extension Decoder {
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

extension Decoder {
    public func decode<T, R>(forKeyPath keyPath: KeyPath, transform: (T) throws -> R) throws -> [String: R] where T: Decodable {
        return try decode(forKeyPath: keyPath, allowInvalidElements: false, transform: transform)
    }

    public func decode<T, R>(forKeyPath keyPath: KeyPath, transform: (T) throws -> R) throws -> [String: R]? where T: Decodable {
        return try decode(forKeyPath: keyPath, allowInvalidElements: false, transform: transform)
    }

    public func decode<T, R>(forKeyPath keyPath: KeyPath, allowInvalidElements: Bool, transform: (T) throws -> R) throws -> [String: R] where T: Decodable {
        let value: [String: T] = try decode(forKeyPath: keyPath, allowInvalidElements: allowInvalidElements)
        return try value.flatMap {
            do {
                return try transform($0)
            } catch {
                throw DecodeError.transformFailure(error, keyPath: keyPath)
            }
        }
    }

    public func decode<T, R>(forKeyPath keyPath: KeyPath, allowInvalidElements: Bool, transform: (T) throws -> R) throws -> [String: R]? where T: Decodable {
        let value: [String: T]? = try decode(forKeyPath: keyPath, allowInvalidElements: allowInvalidElements)
        return try value?.flatMap {
            do {
                return try transform($0)
            } catch {
                throw DecodeError.transformFailure(error, keyPath: keyPath)
            }
        }
    }

    public func decode<T, R>(forKeyPath keyPath: KeyPath, transform: (T) throws -> R) throws -> [String: R?] where T: Decodable {
        let value: [String: T?] = try decode(forKeyPath: keyPath)
        return try value.map {
            do {
                return try $0.map(transform)
            } catch {
                throw DecodeError.transformFailure(error, keyPath: keyPath)
            }
        }
    }

    public func decode<T, R>(forKeyPath keyPath: KeyPath, transform: (T) throws -> R) throws -> [String: R?]? where T: Decodable {
        let value: [String: T?]? = try decode(forKeyPath: keyPath)
        return try value?.flatMap {
            do {
                return try $0.map(transform)
            } catch {
                throw DecodeError.transformFailure(error, keyPath: keyPath)
            }
        }
    }
}
