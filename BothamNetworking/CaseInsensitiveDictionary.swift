public struct CaseInsensitiveDictionary<Value>: Collection,
    ExpressibleByDictionaryLiteral {
    public typealias Key = String
    private var _data: [Key: Value] = [:]
    private var _keyMap: [String: Key] = [:]

    public typealias Element = (key: Key, value: Value)
    public typealias Index = DictionaryIndex<Key, Value>
    public var startIndex: Index {
        return _data.startIndex
    }
    public var endIndex: Index {
        return _data.endIndex
    }
    public func index(after: Index) -> Index {
        return _data.index(after: after)
    }

    public var count: Int {
        assert(_data.count == _keyMap.count, "internal keys out of sync")
        return _data.count
    }

    public var isEmpty: Bool {
        return _data.isEmpty
    }

    public init(dictionaryLiteral elements: (Key, Value)...) {
        for (key, value) in elements {
            _keyMap["\(key)".lowercased()] = key
            _data[key] = value
        }
    }

    public init(dictionary: [Key: Value]) {
        for (key, value) in dictionary {
            _keyMap["\(key)".lowercased()] = key
            _data[key] = value
        }
    }

    static func += <Value> (left: inout CaseInsensitiveDictionary<Value>, right: [String: Value]) {
        for (k, v) in right {
            _ = left.update(value: v, forKey: k)
        }
    }

    public mutating func update(value: Value, forKey key: Key) -> Value? {
                if let realKey = _keyMap["\(key)".lowercased()] {
                        return _data.updateValue(value, forKey: realKey)
                    } else {
                        self[key] = value
        }
             return nil
    }

    public subscript (position: Index) -> Element {
        return _data[position]
    }

    public subscript (key: Key) -> Value? {
        get {
            if let realKey = _keyMap["\(key)".lowercased()] {
                return _data[realKey]
            }
            return nil
        }
        set(newValue) {
            let lowerKey = "\(key)".lowercased()
            if _keyMap[lowerKey] == nil {
                _keyMap[lowerKey] = key
            }
            _data[_keyMap[lowerKey]!] = newValue
        }
    }

    public func makeIterator() -> DictionaryIterator<Key, Value> {
        return _data.makeIterator()
    }

    public var keys: Dictionary<Key, Value>.Keys {
        return _data.keys
    }
    public var values: Dictionary<Key, Value>.Values {
        return _data.values
    }
}
