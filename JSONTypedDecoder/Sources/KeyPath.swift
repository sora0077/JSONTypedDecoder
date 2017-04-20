//
//  KeyPath.swift
//  JSONTypedDecoder
//
//  Created by 林 達也 on 2017/04/20.
//  Copyright © 2017年 sora0077. All rights reserved.
//

import Foundation

public struct KeyPath {
    public enum Component {
        case key(String)
        case index(Int)
    }
    static let empty: KeyPath = []
    fileprivate let components: [Component]
    
    public init(_ keys: Component...) {
        self.init(components: keys)
    }
    
    fileprivate init(components: [Component]) {
        self.components = components
    }
}

// MARK: - extension KeyPath
extension KeyPath: Sequence {
    public func makeIterator() -> IndexingIterator<[Component]> {
        return components.makeIterator()
    }
}

extension KeyPath: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByArrayLiteral {
    public init(stringLiteral value: String) {
        self.init(components: [.key(value)])
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(integerLiteral value: Int) {
        self.init(components: [.index(value)])
    }
    
    public init(arrayLiteral elements: KeyPath.Component...) {
        self.init(components: elements)
    }
}

// MARK: - internal extension KeyPath
extension KeyPath {
    static func + (lhs: KeyPath, rhs: KeyPath) -> KeyPath {
        return KeyPath(components: lhs.components + rhs.components)
    }
}

// MARK: - extension KeyPath.Component
extension KeyPath.Component: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral {
    public init(stringLiteral value: String) {
        self = .key(value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(integerLiteral value: Int) {
        self = .index(value)
    }
}
