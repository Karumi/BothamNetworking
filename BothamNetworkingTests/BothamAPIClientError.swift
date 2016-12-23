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
    case let (.httpResponseError(statusCode1, body1), .httpResponseError(statusCode2, body2)):
        return statusCode1 == statusCode2 && body1 == body2
    case let (.httpClientError(error1), .httpClientError(error2)):
        return error1 == error2
    case (.networkError, .networkError):
        return true
    case (.unsupportedURLScheme, .unsupportedURLScheme):
        return true
    case (.parsingError(_), .parsingError(_)):
        return true
    case (.retry, .retry):
        return true
    default:
        return false
    }
}
