//
//  decode.swift
//  JSONTypedDecoder
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> T where T: Decodable {
    let decoder = try rootKeyPath.map { try JSONDecoder(any, rootKeyPath: $0) } ?? JSONDecoder(any)
    return try T.decode(decoder)
}
