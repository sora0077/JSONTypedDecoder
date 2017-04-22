//
//  Decodable+RawRepresentable.swift
//  Alter
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

extension RawRepresentable where Self: Decodable, RawValue: Decodable {
    public static func decode(_ decoder: Decoder) throws -> Self {
        let rawValue = try RawValue.decode(decoder)
        guard let value = self.init(rawValue: rawValue) else {
            throw DecodeError.typeMismatch(expected: self, actual: rawValue, keyPath: .empty)
        }
        return value
    }
}
