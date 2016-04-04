//
//  RetryResponseInterceptor.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 14/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation
import BothamNetworking
import Result

class RetryResponseInterceptor: BothamResponseInterceptor {

    var interceptCalls = 0
    var numberOfRetries: Int

    init(numberOfRetries: Int) {
        self.numberOfRetries = numberOfRetries
    }

    func intercept(response: HTTPResponse, completion: (Result<HTTPResponse, BothamAPIClientError>) -> Void) {
        interceptCalls += 1
        if numberOfRetries > 0 {
            numberOfRetries -= 1
            completion(Result.Failure(.Retry))
        } else {
            completion(Result.Success(response))
        }
    }
}