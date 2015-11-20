//
//  HTTPRequest.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

struct HTTPRequest {

    let url: String
    let parameters: [String : String]?
    let headers: [String : String]?
    let httpMethod: HTTPMethod
    
}