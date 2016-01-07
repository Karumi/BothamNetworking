//
//  NSLogInterceptor.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 04/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation

public class NSLogInterceptor: BothamRequestInterceptor, BothamResponseInterceptor {

    public init() {}

    public func intercept(request: HTTPRequest) -> HTTPRequest {
        NSLog("-> \(request)")
        return request
    }

    public func intercept(response: HTTPResponse) -> HTTPResponse {
        NSLog("<- \(response)")
        return response
    }
}
