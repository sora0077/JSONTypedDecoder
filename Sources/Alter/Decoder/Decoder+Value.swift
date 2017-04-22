//
//  Decoder+Value.swift
//  Alter
//
//  Created by 林達也 on 2017/04/22.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

extension Decoder {
    public func decode(forKeyPath keyPath: KeyPath) throws -> Any? {
        do {
            return try decode(forKeyPath: keyPath) as Any
        } catch DecodeError.missingKeyPath {
            return nil
        }
    }

    public func decode<T>(forKeyPath keyPath: KeyPath) throws -> T? where T: Decodable {
        do {
            return try decode(forKeyPath: keyPath) as T
        } catch DecodeError.missingKeyPath {
            return nil
        }
    }
}
