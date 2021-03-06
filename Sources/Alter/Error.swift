//
//  Error.swift
//  Alter
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

public enum DecodeError: Error {
    case missingKeyPath(KeyPath)
    case typeMismatch(expected: Any.Type, actual: Any?, keyPath: KeyPath)
    case transformFailure(Error, keyPath: KeyPath)
}
