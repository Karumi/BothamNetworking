//
//  Dictionary.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 29/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>?, right: Dictionary<KeyType, ValueType>) {
    if left == nil {
        left = [KeyType:ValueType]()
    }
    for (k, v) in right {
        left?.updateValue(v, forKey: k)
    }
}