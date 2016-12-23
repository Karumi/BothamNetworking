//
//  Dictionary.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 29/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

extension Dictionary {
    init<S: Sequence>(_ seq: S) where S.Iterator.Element == (Key, Value) {
        self.init()
        for (k, v) in seq {
            self[k] = v
        }
    }
}

func += <KeyType, ValueType> (left: inout Dictionary<KeyType, ValueType>?, right: Dictionary<KeyType, ValueType>) {
    if left == nil {
        left = [KeyType:ValueType]()
    }
    for (k, v) in right {
        left?.updateValue(v, forKey: k)
    }
}

func += <KeyType, ValueType> (left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
