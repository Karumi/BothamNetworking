//
//  SpyRequestInterceptor.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 28/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
@testable import BothamNetworking


class SpyRequestInterceptor: BothamRequestInterceptor {

    var intercepted: Bool = false
    var interceptedRequest: HTTPRequest!

    func intercept(request: HTTPRequest) -> HTTPRequest {
        intercepted = true
        interceptedRequest = request
        return request
    }
}