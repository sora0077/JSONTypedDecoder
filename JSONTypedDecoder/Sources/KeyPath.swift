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
    
    init(components: [Component]) {
        self.components = components
    }
}

// MARK: - extension KeyPath
extension KeyPath: Sequence {
    public func makeIterator() -> IndexingIterator<[Component]> {
        return components.makeIterator()
    }
}

extension KeyPath: BidirectionalCollection {
    public var startIndex: Int { return components.startIndex }
    public var endIndex: Int { return components.endIndex }
    
    public subscript(index: Int) -> Component {
        return components[index]
    }
    
    public func index(before i: Int) -> Int {
        return components.index(before: i)
    }
    
    public func index(after i: Int) -> Int {
        return components.index(after: i)
    }
}

extension KeyPath: CustomStringConvertible {
    public var description: String {
        var result: [String] = []
        for key in self {
            switch key {
            case .key(let key):
                result.append(key)
            case .index(let index):
                result.append("\(index)")
            }
        }
        return result.joined(separator: ".")
    }
}

extension KeyPath: Equatable {
    public static func == (lhs: KeyPath, rhs: KeyPath) -> Bool {
        return lhs.components == rhs.components
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
extension KeyPath.Component: Equatable {
    public static func == (lhs: KeyPath.Component, rhs: KeyPath.Component) -> Bool {
        switch (lhs, rhs) {
        case (.key(let lhs), .key(let rhs)): return lhs == rhs
        case (.index(let lhs), .index(let rhs)): return lhs == rhs
        default: return false
        }
    }
}
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
