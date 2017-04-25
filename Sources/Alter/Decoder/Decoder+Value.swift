//
//  Decoder+Value.swift
//  Alter
//
//  Created by 林 達也 on 2017/04/25.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

extension Decoder {
    public func decode<T>(forKeyPath keyPath: KeyPath, optional: Bool) throws -> T? where T: Decodable {
        do {
            return try decode(forKeyPath: keyPath)
        } catch DecodeError.missingKeyPath(let missing) where optional && checkOptional(missing: missing, for: keyPath) {
            return nil
        }
    }
}
