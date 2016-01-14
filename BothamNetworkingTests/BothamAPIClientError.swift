//
//  BothamAPIClientError.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 14/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation
import BothamNetworking

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
    case (.ParsingError(_), .ParsingError(_)):
        return true
    case (.Retry, .Retry):
        return true
    default:
        return false
    }
}