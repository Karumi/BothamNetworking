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
    public let body: [String:AnyObject]?

    public var encodedBody: Data? {
        get {
            return HTTPEncoder.encodeBody(self)
        }
    }

    public init(url: String,
        parameters: [String:String]?,
        headers: [String:String]?,
        httpMethod: HTTPMethod,
        body: [String:AnyObject]?) {
            self.url = url
            self.parameters = parameters
            self.headers = headers
            self.httpMethod = httpMethod
            self.body = body
    }

    
    public func withURL(_ url: String) -> HTTPRequest {
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: headers,
            httpMethod: httpMethod,
            body: body)
    }

    
    public func withParameters(_ parameters: [String:String]) -> HTTPRequest {
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: headers,
            httpMethod: httpMethod,
            body: body)
    }

    
    public func withHeaders(_ headers: [String:String]?) -> HTTPRequest {
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: headers,
            httpMethod: httpMethod,
            body: body)
    }

    
    public func withHTTPMethod(_ httpMethod: HTTPMethod) -> HTTPRequest {
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: headers,
            httpMethod: httpMethod,
            body: body)
    }

    
    public func withBody(_ body: [String:AnyObject]?) -> HTTPRequest {
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: headers,
            httpMethod: httpMethod,
            body: body)
    }

    
    public func appendingHeaders(_ headers: [String:String]) -> HTTPRequest {
        var newHeaders = self.headers
        newHeaders += headers
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: newHeaders,
            httpMethod: httpMethod,
            body: body)
    }

    
    public func appendingParameters(_ parameters: [String:String]) -> HTTPRequest {
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
            let headers = self.headers?.map {
                (key, value) in "\(key): \(value)\n"
                }.joined(separator: "\n") ?? ""
            let parameters = self.parameters?.map {
                (key, value) in "\(key): \(value)\n"
                }.joined(separator: "\n") ?? ""
            let encodedBody = String(data: self.encodedBody ?? Data(), encoding: String.Encoding.utf8)!
            return "\(httpMethod.rawValue) \(url)"
            + "\(parameters)\n"
            + "\(headers)\n"
            + "\(encodedBody)\n"
        }
    }

}
