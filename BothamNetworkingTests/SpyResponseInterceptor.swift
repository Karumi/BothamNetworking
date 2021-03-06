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
    var error: BothamAPIClientError?

    func intercept(_ response: HTTPResponse, completion: (Result<HTTPResponse, BothamAPIClientError>) -> Void) {
        intercepted = true
        interceptedResponse = response
        if let error = error {
            completion(Result.failure(error))
        } else {
            completion(Result.success(response))
        }
    }
}

