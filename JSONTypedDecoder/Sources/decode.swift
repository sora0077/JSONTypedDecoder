//
//  decode.swift
//  JSONTypedDecoder
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

public func decode<T>(_ any: Any) throws -> T where T: Decodable {
    return try T.decode(JSONDecoder(any))
}

public func decode<T>(_ any: Any, rootKeyPath: KeyPath) throws -> T where T: Decodable {
    return try T.decode(JSONDecoder(any, rootKeyPath: rootKeyPath))
}
