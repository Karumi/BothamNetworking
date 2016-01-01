//
//  CaseInsensitiveDictionary.swift
//  BothamNetworking
//
//  Created by Davide Mendolia on 01/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation
/*
public struct CaseInsensitiveDictionary<Value>: CollectionType, DictionaryLiteralConvertible {
    public typealias Key = String

    private var _data:[Key: Value] = [:]
    private var _keyMap: [String: Key] = [:]

    typealias Element = (Key, Value)
    public typealias Index = DictionaryIndex<Key, Value>
    public var startIndex: Index
    public var endIndex: Index

    public var count: Int {
        assert(_data.count == _keyMap.count, "internal keys out of sync")
        return _data.count
    }

    public var isEmpty: Bool {
        return _data.isEmpty
    }

    init() {
        startIndex = _data.startIndex
        endIndex = _data.endIndex
    }

    public init(dictionaryLiteral elements: (Key, Value)...) {
        for (key, value) in elements {
            _keyMap["\(key)".lowercaseString] = key
            _data[key] = value
        }
        startIndex = _data.startIndex
        endIndex = _data.endIndex
    }

    public subscript (position: Index) -> Element {
        return _data[position]
    }

    subscript (key: Key) -> Value? {
        get {
            if let realKey = _keyMap["\(key)".lowercaseString] {
                return _data[realKey]
            }
            return nil
        }
        set(newValue) {
            let lowerKey = "\(key)".lowercaseString
            if _keyMap[lowerKey] == nil {
                _keyMap[lowerKey] = key
            }
            _data[_keyMap[lowerKey]!] = newValue
        }
    }

    public func generate() -> DictionaryGenerator<Key, Value> {
        return _data.generate()
    }
}*/

/// A hash-based mapping from `Key` to `Value` instances.  Also a
/// collection of key-value pairs with no defined ordering.
public struct CaseInsensitiveDictionary<Value> : CollectionType, DictionaryLiteralConvertible {
    public typealias Key = String
    public typealias Element = (Key, Value)
    public typealias Index = DictionaryIndex<Key, Value>

    private var data:[Key: Value] = [:]
    private var keyMap: [String: Key] = [:]


    /// Create an empty dictionary.
    public init() {
        data = Dictionary()
        keyMap = Dictionary()
    }

    /// Create a dictionary with at least the given number of
    /// elements worth of storage.  The actual capacity will be the
    /// smallest power of 2 that's >= `minimumCapacity`.
    public init(minimumCapacity: Int) {
        data = Dictionary(minimumCapacity: minimumCapacity)
        keyMap = Dictionary(minimumCapacity: minimumCapacity)
    }

    /// The position of the first element in a non-empty dictionary.
    ///
    /// Identical to `endIndex` in an empty dictionary.
    ///
    /// - Complexity: Amortized O(1) if `self` does not wrap a bridged
    ///   `NSDictionary`, O(N) otherwise.
    public var startIndex: DictionaryIndex<Key, Value> {
        return data.startIndex
    }

    /// The collection's "past the end" position.
    ///
    /// `endIndex` is not a valid argument to `subscript`, and is always
    /// reachable from `startIndex` by zero or more applications of
    /// `successor()`.
    ///
    /// - Complexity: Amortized O(1) if `self` does not wrap a bridged
    ///   `NSDictionary`, O(N) otherwise.
    public var endIndex: DictionaryIndex<Key, Value> {
        return data.endIndex
    }

    /// Returns the `Index` for the given key, or `nil` if the key is not
    /// present in the dictionary.
    @warn_unused_result
    public func indexForKey(key: Key) -> DictionaryIndex<Key, Value>? {
        return data.indexForKey(key)
    }

    public subscript (position: DictionaryIndex<Key, Value>) -> (Key, Value) {
        return data[position]
    }

    public subscript (key: Key) -> Value? {
        return data[key]
    }

    /// Update the value stored in the dictionary for the given key, or, if they
    /// key does not exist, add a new key-value pair to the dictionary.
    ///
    /// Returns the value that was replaced, or `nil` if a new key-value pair
    /// was added.
    public mutating func updateValue(value: Value, forKey key: Key) -> Value? {
        return data.updateValue(value, forKey: key)
    }

    /// Remove the key-value pair at `index`.
    ///
    /// Invalidates all indices with respect to `self`.
    ///
    /// - Complexity: O(`count`).
    public mutating func removeAtIndex(index: DictionaryIndex<Key, Value>) -> (Key, Value) {
        return data.removeAtIndex(index)
    }

    /// Remove a given key and the associated value from the dictionary.
    /// Returns the value that was removed, or `nil` if the key was not present
    /// in the dictionary.
    public mutating func removeValueForKey(key: Key) -> Value? {
        return data.removeValueForKey(key)
    }

    /// Remove all elements.
    ///
    /// - Postcondition: `capacity == 0` if `keepCapacity` is `false`, otherwise
    ///   the capacity will not be decreased.
    ///
    /// Invalidates all indices with respect to `self`.
    ///
    /// - parameter keepCapacity: If `true`, the operation preserves the
    ///   storage capacity that the collection has, otherwise the underlying
    ///   storage is released.  The default is `false`.
    ///
    /// Complexity: O(`count`).
    public mutating func removeAll(keepCapacity keepCapacity: Bool = false) {
        return data.removeAll(keepCapacity: keepCapacity)
    }

    /// The number of entries in the dictionary.
    ///
    /// - Complexity: O(1).
    public var count: Int { return data.count }

    /// Return a *generator* over the (key, value) pairs.
    ///
    /// - Complexity: O(1).
    public func generate() -> DictionaryGenerator<Key, Value> {
        return data.generate()
    }

    /// Create an instance initialized with `elements`.
    public init(dictionaryLiteral elements: (Key, Value)...) {
        data = Dictionary(elements)
    }

    /// A collection containing just the keys of `self`.
    ///
    /// Keys appear in the same order as they occur as the `.0` member
    /// of key-value pairs in `self`.  Each key in the result has a
    /// unique value.
    public var keys: LazyMapCollection<[Key : Value], Key> {
        return data.keys
    }

    /// A collection containing just the values of `self`.
    ///
    /// Values appear in the same order as they occur as the `.1` member
    /// of key-value pairs in `self`.
    public var values: LazyMapCollection<[Key : Value], Value> {
        return data.values
    }

    /// `true` iff `count == 0`.
    public var isEmpty: Bool {
        return data.isEmpty
    }
}