//
//  HTTPResponse.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

public struct HTTPResponse {

    public let statusCode: Int
    public let headers: CaseInsensitiveDictionary<String>?
    public let body: NSData

    @warn_unused_result
    public func withStatusCode(statusCode: Int) -> HTTPResponse {
        return HTTPResponse(
            statusCode: statusCode,
            headers: headers,
            body: body)
    }

    @warn_unused_result
    public func withHeaders(headers: [String:String]?) -> HTTPResponse {
        return HTTPResponse(
            statusCode: statusCode,
            headers: CaseInsensitiveDictionary(dictionary: headers ?? [ : ]),
            body: body)
    }

    @warn_unused_result
    public func appendHeaders(headers: [String:String]) -> HTTPResponse {
        var newHeaders = self.headers
        newHeaders += headers
        return HTTPResponse(
            statusCode: statusCode,
            headers: newHeaders,
            body: body)
    }

    @warn_unused_result
    public func withBody(body: NSData) -> HTTPResponse {
        return HTTPResponse(
            statusCode: statusCode,
            headers: headers,
            body: body)
    }

}