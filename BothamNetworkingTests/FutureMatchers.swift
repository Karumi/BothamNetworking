//
//  FutureMatchers.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Nimble
import BrightFutures
@testable import BothamNetworking

func beSuccess<T>() -> MatcherFunc<T?> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be success"
        let future = try actualExpression.evaluate() as! Future<HTTPResponse, NSError>
        return future.isSuccess
    }
}

func beBothamRequestSuccess<T>() -> MatcherFunc<T?> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be success"
        let future = try actualExpression.evaluate() as! Future<HTTPResponse, BothamAPIClientError>
        return future.isSuccess
    }
}

func failWithError<T>(expectedError: BothamAPIClientError) -> MatcherFunc<T?> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "has error"
        let future = try actualExpression.evaluate() as! Future<HTTPResponse, BothamAPIClientError>
        if let error = future.error {
            return expectedError == error
        } else {
            return false
        }
    }
}

func failWithError<T>(expectedError: NSError) -> MatcherFunc<T?> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "has error"
        let future = try actualExpression.evaluate() as! Future<HTTPResponse, NSError>
        if let error = future.error {
            return expectedError == error
        } else {
            return false
        }
    }
}

extension BothamAPIClientError: Equatable { }

public func == (lhs: BothamAPIClientError, rhs: BothamAPIClientError) -> Bool {
    switch (lhs, rhs) {
    case let (.HTTPResponseError(statusCode1, body1), .HTTPResponseError(statusCode2, body2)):
        return statusCode1 == statusCode2 && body1 == body2
    case let (.HTTPClientError(error1), .HTTPClientError(error2)):
        return error1 == error2
    case (.NetworkError, .NetworkError):
        return true
    case (.UnsupportedURLScheme, .UnsupportedURLScheme):
        return true
    default:
        return false
    }
}
