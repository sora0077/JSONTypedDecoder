//
//  decode.swift
//  JSONTypedDecoder
//
//  Created by 林達也 on 2017/04/21.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> T where T: Decodable {
    return try T.decode(JSONDecoder(any, rootKeyPath: rootKeyPath ?? .empty))
}

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> [T] where T: Decodable {
    let decoder = try JSONDecoder(any, rootKeyPath: rootKeyPath ?? .empty)
    return try decoder.array().map {
        try T.decode(JSONDecoder($0, rootKeyPath: .empty))
    }
}

public func decode<T>(_ any: Any, rootKeyPath: KeyPath? = nil) throws -> [String: T] where T: Decodable {
    let decoder = try JSONDecoder(any, rootKeyPath: rootKeyPath ?? .empty)
    return try decoder.dictionary().map {
        try T.decode(JSONDecoder($0, rootKeyPath: .empty))
    }
}
