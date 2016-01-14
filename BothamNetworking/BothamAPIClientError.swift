//
//  BothamAPIClientError.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 23/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

public enum BothamAPIClientError: ErrorType {

    case HTTPResponseError(statusCode: Int, body: NSData)
    case NetworkError
    case HTTPClientError(error: NSError)
    case ParsingError(error: NSError)
    case UnsupportedURLScheme
    case Retry

}
