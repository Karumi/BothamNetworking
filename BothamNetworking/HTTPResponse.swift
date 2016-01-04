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
    public let headers: [String:String]?
    public let body: NSData

    public func withStatusCode(statusCode: Int) -> HTTPResponse {
        return HTTPResponse(
            statusCode: statusCode,
            headers: headers,
            body: body)
    }

    public func withHeaders(headers: [String:String]?) -> HTTPResponse {
        return HTTPResponse(
            statusCode: statusCode,
            headers: headers,
            body: body)
    }

    public func appendHeaders(headers: [String:String]) -> HTTPResponse {
        var newHeaders = self.headers
        newHeaders += headers
        return HTTPResponse(
            statusCode: statusCode,
            headers: newHeaders,
            body: body)
    }

    public func withBody(body: NSData) -> HTTPResponse {
        return HTTPResponse(
            statusCode: statusCode,
            headers: headers,
            body: body)
    }

}

extension HTTPResponse: CustomDebugStringConvertible {

    public var debugDescription: String {
        get {
            return "\(statusCode)\n"
                + "Headers: \(headers)\n"
                + "Body: \(body)\n"
        }
    }

}