//
//  HTTPRequest.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

public struct HTTPRequest {

    public let url: String
    public let parameters: [String:AnyObject]?
    public let headers: [String:String]?
    public let httpMethod: HTTPMethod
    public let body: [String:AnyObject]?

}