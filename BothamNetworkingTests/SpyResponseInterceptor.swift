//
//  SpyResponseInterceptor.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 29/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
@testable import BothamNetworking

class SpyResponseInterceptor: BothamResponseInterceptor {

    var intercepted: Bool = false
    var interceptedResponse: HTTPResponse!

    func intercept(response: HTTPResponse) -> HTTPResponse {
        intercepted = true
        interceptedResponse = response
        return response
    }
}

