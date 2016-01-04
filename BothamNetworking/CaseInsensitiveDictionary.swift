//
//  CaseInsensitiveDictionary.swift
//  BothamNetworking
//
//  Created by Davide Mendolia on 01/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation

/// A hash-based mapping from `Key` to `Value` instances.  Also a
/// collection of key-value pairs with no defined ordering.
public struct CaseInsensitiveDictionary<Value> : CollectionType, DictionaryLiteralConvertible {
    public typealias Key = String
    public typealias Element = (Key, Value)
    public typealias Index = DictionaryIndex<Key, Value>

    private var data: [Key: Value] = [:]
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

    public init(dictionary: [Key: Value]) {
        self.init()
        data = dictionary
        for (key, _) in dictionary {
            keyMap["\(key)".lowercaseString] = key
        }
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
        if let realKey = keyMap["\(key)".lowercaseString] {
            return data.indexForKey(realKey)
        }
        return nil
    }

    public subscript (position: DictionaryIndex<Key, Value>) -> (Key, Value) {
        return data[position]
    }

    public subscript (key: Key) -> Value? {
        get {
            if let realKey = keyMap["\(key)".lowercaseString] {
                return data[realKey]
            }
            return nil
        }
        set(newValue) {
            let lowerKey = "\(key)".lowercaseString
            if keyMap[lowerKey] == nil {
                keyMap[lowerKey] = key
            }
            data[keyMap[lowerKey]!] = newValue
        }
    }


    /// Update the value stored in the dictionary for the given key, or, if they
    /// key does not exist, add a new key-value pair to the dictionary.
    ///
    /// Returns the value that was replaced, or `nil` if a new key-value pair
    /// was added.
    public mutating func updateValue(value: Value, forKey key: Key) -> Value? {
        if let realKey = keyMap["\(key)".lowercaseString] {
            return data.updateValue(value, forKey: realKey)
        } else {
            self[key] = value
        }
        return nil
    }

    /// Remove a given key and the associated value from the dictionary.
    /// Returns the value that was removed, or `nil` if the key was not present
    /// in the dictionary.
    public mutating func removeValueForKey(key: Key) -> Value? {
        if let realKey = keyMap["\(key)".lowercaseString] {
            keyMap.removeValueForKey(key)
            return data.removeValueForKey(realKey)
        }
        return nil
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
        keyMap.removeAll()
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
        for (key, _) in elements {
            keyMap["\(key)".lowercaseString] = key
        }
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

func += <ValueType> (inout left: CaseInsensitiveDictionary<ValueType>?, right: Dictionary<String, ValueType>) {
    if left == nil {
        left = CaseInsensitiveDictionary()
    }
    for (k, v) in right {
        left?.updateValue(v, forKey: k)
    }
}

extension CaseInsensitiveDictionary : CustomDebugStringConvertible {
    public var debugDescription: String {
        get { return "\(data)" }
    }
}