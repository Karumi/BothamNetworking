//
//  BothamAPIClientError.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 23/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

public enum BothamAPIClientError: Error {

    case httpResponseError(statusCode: Int, body: Data)
    case networkError
    case httpClientError(error: NSError)
    case parsingError(error: NSError)
    case unsupportedURLScheme
    case retry

}
