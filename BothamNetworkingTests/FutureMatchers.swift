//
//  FutureMatchers.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Nimble
import Result
@testable import BothamNetworking

func beSuccess<T>() -> MatcherFunc<T?> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be success"
        let result = try actualExpression.evaluate() as? Result<HTTPResponse, BothamAPIClientError>
        return result?.value != nil
    }
}

func failWithError<T>(expectedError: BothamAPIClientError) -> MatcherFunc<T?> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "has error"
        let result = try actualExpression.evaluate() as? Result<HTTPResponse, BothamAPIClientError>
        if let error = result?.error {
            return expectedError == error
        } else {
            return false
        }
    }
}

func failWithError<T>(expectedError: NSError) -> MatcherFunc<T?> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "has error"
        let result = try actualExpression.evaluate() as? Result<HTTPResponse, NSError>
        if let error = result?.error {
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
