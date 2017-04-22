//
//  Decoder.swift
//  Alter
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

public protocol Decoder {
    var rawValue: Any { get }

    init(_ any: Any, rootKeyPath: KeyPath?) throws
    func decode(forKeyPath keyPath: KeyPath) throws -> Any
    func decode<T>(forKeyPath keyPath: KeyPath) throws -> T where T: Decodable
    func decode<T>(forKeyPath keyPath: KeyPath) throws -> [T?] where T: Decodable
    func decode<T>(forKeyPath keyPath: KeyPath) throws -> [String: T?] where T: Decodable

    #if os(macOS)
    func decode<T>(forKeyPath keyPath: KeyPath) throws -> T? where T: Decodable
    #endif
}
