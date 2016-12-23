//
//  JSONHeadersRequestInterceptor.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 14/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation

open class JSONHeadersRequestInterceptor: BothamRequestInterceptor {

    public init() {}

    open func intercept(_ request: HTTPRequest) -> HTTPRequest {
        return request.appendingHeaders(["Accept": "application/json",
            "Content-Type": "application/json"])
    }
}
