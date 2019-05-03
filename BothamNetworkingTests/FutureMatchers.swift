//
//  FutureMatchers.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Nimble
@testable import BothamNetworking

public func beSuccess<T>() -> Predicate<T> {
    return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be success"
        let result = try actualExpression.evaluate() as? Result<HTTPResponse, BothamAPIClientError>
        return try! result?.get() != nil
    }
}

public func failWithError<T>(_ expectedError: BothamAPIClientError) -> Predicate<T> {
    return Predicate.fromDeprecatedClosure { actualExpression, failureMessage in
        failureMessage.postfixMessage = "has error"
        let result = try actualExpression.evaluate() as? Result<HTTPResponse, BothamAPIClientError>
        if case let .failure(error)? = result {
            return expectedError == error
        } else {
            return false
        }
    }
}

