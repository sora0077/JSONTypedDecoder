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

    func decode(forKeyPath keyPath: KeyPath) throws -> Any
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
}
