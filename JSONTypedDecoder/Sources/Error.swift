//
//  Error.swift
//  JSONTypedDecoder
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

public enum Error: Swift.Error {
    case missingKeyPath(KeyPath)
    case typeMissmatch(expected: Any.Type, actual: Any, keyPath: KeyPath)
    case transformFailure(Swift.Error, keyPath: KeyPath)
}
