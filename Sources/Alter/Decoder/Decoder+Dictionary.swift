//
//  Decoder+Dictionary.swift
//  Alter
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

extension Decoder {
    public func decode<T>(forKeyPath keyPath: KeyPath, skipInvalidElements: Bool = false) throws -> [String: T] where T: Decodable {
        let dict: [String: T?] = try decode(forKeyPath: keyPath)
        return try dict.flatMap {
            guard let value = $0 else {
                if skipInvalidElements { return nil }
                throw DecodeError.typeMismatch(expected: T.self, actual: $0, keyPath: keyPath)
            }
            return value
        }
    }
}
