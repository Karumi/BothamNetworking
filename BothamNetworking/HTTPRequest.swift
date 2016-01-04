//
//  HTTPRequest.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

public struct HTTPRequest {

    public let url: String
    public let parameters: [String:String]?
    public let headers: [String:String]?
    public let httpMethod: HTTPMethod
    public let body: NSData?

    public func withURL(url: String) -> HTTPRequest {
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: headers,
            httpMethod: httpMethod,
            body: body)
    }

    public func withParameters(parameters: [String:String]?) -> HTTPRequest {
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: headers,
            httpMethod: httpMethod,
            body: body)
    }

    public func withHeaders(headers: [String:String]?) -> HTTPRequest {
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: headers,
            httpMethod: httpMethod,
            body: body)
    }

    public func withHTTPMethod(httpMethod: HTTPMethod) -> HTTPRequest {
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: headers,
            httpMethod: httpMethod,
            body: body)
    }

    public func withBody(body: NSData?) -> HTTPRequest {
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: headers,
            httpMethod: httpMethod,
            body: body)
    }

    public func appendHeaders(headers: [String:String]) -> HTTPRequest {
        var newHeaders = self.headers
        newHeaders += headers
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: newHeaders,
            httpMethod: httpMethod,
            body: body)
    }

    public func appendParameters(parameters: [String:String]) -> HTTPRequest {
        var newParameters = self.parameters
        newParameters += parameters
        return HTTPRequest(
            url: url,
            parameters: newParameters,
            headers: headers,
            httpMethod: httpMethod,
            body: body)
    }

}

extension HTTPRequest: CustomDebugStringConvertible {

    public var debugDescription: String {
        get {
            return "\(httpMethod.rawValue) \(url)\n"
            + "Headers: \(headers)\n"
            + "Parameters: \(parameters)\n"
            + "Body: \(body)\n"
        }
    }

}