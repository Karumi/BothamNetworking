//
//  SpyResponseInterceptor.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 29/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Result
@testable import BothamNetworking

class SpyResponseInterceptor: BothamResponseInterceptor {

    var intercepted: Bool = false
    var interceptedResponse: HTTPResponse!

    func intercept(response: HTTPResponse, completion: (Result<HTTPResponse, BothamAPIClientError>) -> Void) {
        intercepted = true
        interceptedResponse = response
        completion(Result.Success(response))
    }
}

