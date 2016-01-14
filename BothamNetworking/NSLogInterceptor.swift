//
//  NSLogInterceptor.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 04/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation
import Result

public class NSLogInterceptor: BothamRequestInterceptor, BothamResponseInterceptor {

    public init() {}

    public func intercept(request: HTTPRequest) -> HTTPRequest {
        NSLog("-> \(request)")
        return request
    }

    public func intercept(response: HTTPResponse,
        completion: (Result<HTTPResponse, BothamAPIClientError>) -> Void) {
            if response.statusCode == 401 {
                completion(Result.Failure(.RetryError))
            } else {
                completion(Result.Success(response))
            }
    }
}
