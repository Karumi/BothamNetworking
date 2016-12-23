//
//  NSLogInterceptor.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 04/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation
import Result

open class NSLogInterceptor: BothamRequestInterceptor, BothamResponseInterceptor {

    public init() {}

    open func intercept(_ request: HTTPRequest) -> HTTPRequest {
        NSLog("-> \(request)")
        return request
    }

    open func intercept(_ response: HTTPResponse,
        completion: (Result<HTTPResponse, BothamAPIClientError>) -> Void) {
            NSLog("<- \(response)")
            completion(Result.success(response))
    }
}
