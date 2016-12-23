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

    var timeout: TimeInterval { get }

    func send(_ httpRequest: HTTPRequest, completion: @escaping (Result<HTTPResponse, BothamAPIClientError>) -> ())

    func hasValidScheme(_ httpRequest: HTTPRequest) -> Bool

    func isValidResponse(_ httpRespone: HTTPResponse) -> Bool

    func mapNSErrorToBothamError(_ error: NSError) -> BothamAPIClientError

}

extension HTTPClient {

    public var timeout: TimeInterval {
        get {
            return 10
        }
    }

    public func hasValidScheme(_ request: HTTPRequest) -> Bool {
        return request.url.hasPrefix("http") || request.url.hasPrefix("https")
    }

    public func isValidResponse(_ response: HTTPResponse) -> Bool {
        return 200..<300 ~= response.statusCode
    }

    public func mapNSErrorToBothamError(_ error: NSError) -> BothamAPIClientError {
        let connectionErrors = [NSURLErrorCancelled,
            NSURLErrorTimedOut,
            NSURLErrorCannotConnectToHost,
            NSURLErrorNetworkConnectionLost,
            NSURLErrorNotConnectedToInternet,
            NSURLErrorRequestBodyStreamExhausted
        ]
        if connectionErrors.contains(error.code) {
            return .networkError
        } else {
            return .httpClientError(error: error)
        }
    }

}
