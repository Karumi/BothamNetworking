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

public func beSuccess<T>() -> Predicate<T> {
    return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be success"
        let result = try actualExpression.evaluate() as? Result<HTTPResponse, BothamAPIClientError>
        return result?.value != nil
    }
}

public func failWithError<T>(_ expectedError: BothamAPIClientError) -> Predicate<T> {
    return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
        failureMessage.postfixMessage = "has error"
        let result = try actualExpression.evaluate() as? Result<HTTPResponse, BothamAPIClientError>
        if let error = result?.error {
            return expectedError == error
        } else {
            return false
        }
    }
}

