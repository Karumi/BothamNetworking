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

    func send(httpRequest: HTTPRequest, completion: (Result<HTTPResponse, NSError>) -> ())

    func hasValidScheme(httpRequest: HTTPRequest) -> Bool

    func isValidResponse(httpRespone: HTTPResponse) -> Bool

}

extension HTTPClient {

    public func hasValidScheme(request: HTTPRequest) -> Bool {
        return request.url.hasPrefix("http") || request.url.hasPrefix("https")
    }

    public func isValidResponse(response: HTTPResponse) -> Bool {
        let containsValidHTTPStatusCode = 200..<300 ~= response.statusCode
        let containsJsonContentType = response.headers?["Content-Type"] == "application/json"
        return containsValidHTTPStatusCode && containsJsonContentType
    }

}