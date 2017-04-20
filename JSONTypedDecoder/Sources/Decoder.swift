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
}
