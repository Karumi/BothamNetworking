//
//  BothamAPIClientError.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 23/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

public enum BothamAPIClientError: ErrorType, Equatable {

    case HTTPResponseError(statusCode: Int, body: NSData)
    case NetworkError
    case HTTPClientError(error: NSError)
    case ParsingError(error: NSError)
    case UnsupportedURLScheme
    case Retry

}

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
    case (.ParsingError(_), .ParsingError(_)):
        return true
    case (.Retry, .Retry):
        return true
    default:
        return false
    }
}
