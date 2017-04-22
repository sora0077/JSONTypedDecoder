//
//  Decodable.swift
//  Alter
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

public protocol Decodable {
    static func decode(_ decoder: Decoder) throws -> Self
}

public protocol PrimitiveDecodable: Decodable {}
