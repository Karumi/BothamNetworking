//
//  HTTPClient.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

import Foundation
import Result

public protocol HTTPClient {

    var timeout: NSTimeInterval { get }

    func send(httpRequest: HTTPRequest, completion: (Result<HTTPResponse, BothamAPIClientError>) -> ())

    func hasValidScheme(httpRequest: HTTPRequest) -> Bool

    func isValidResponse(httpRespone: HTTPResponse) -> Bool

    func mapNSErrorToBothamError(error: NSError) -> BothamAPIClientError

}

extension HTTPClient {

    public var timeout: NSTimeInterval {
        get {
            return 10
        }
    }

    public func hasValidScheme(request: HTTPRequest) -> Bool {
        return request.url.hasPrefix("http") || request.url.hasPrefix("https")
    }

    public func isValidResponse(response: HTTPResponse) -> Bool {
        return 200..<300 ~= response.statusCode
    }

    public func mapNSErrorToBothamError(error: NSError) -> BothamAPIClientError {
        let connectionErrors = [NSURLErrorCancelled,
            NSURLErrorTimedOut,
            NSURLErrorCannotConnectToHost,
            NSURLErrorNetworkConnectionLost,
            NSURLErrorNotConnectedToInternet,
            NSURLErrorRequestBodyStreamExhausted
        ]
        if connectionErrors.contains(error.code) {
            return .NetworkError
        } else {
            return .HTTPClientError(error: error)
        }
    }

}