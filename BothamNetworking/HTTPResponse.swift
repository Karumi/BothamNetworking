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
    public let body: Data

    public init(statusCode: Int,
        headers: CaseInsensitiveDictionary<String>?,
        body: Data) {
            self.statusCode = statusCode
            self.headers = headers
            self.body = body
    }

    
    public func withStatusCode(_ statusCode: Int) -> HTTPResponse {
        return HTTPResponse(
            statusCode: statusCode,
            headers: headers,
            body: body)
    }

    
    public func withHeaders(_ headers: [String:String]?) -> HTTPResponse {
        return HTTPResponse(
            statusCode: statusCode,
            headers: CaseInsensitiveDictionary(dictionary: headers ?? [ : ]),
            body: body)
    }

    
    public func appendingHeaders(_ headers: [String:String]) -> HTTPResponse {
        var newHeaders = self.headers
        newHeaders += headers
        return HTTPResponse(
            statusCode: statusCode,
            headers: newHeaders,
            body: body)
    }

    
    public func withBody(_ body: Data) -> HTTPResponse {
        return HTTPResponse(
            statusCode: statusCode,
            headers: headers,
            body: body)
    }

}

extension HTTPResponse: CustomDebugStringConvertible {

    public var debugDescription: String {
        get {
            let headers = self.headers?.map {
                (key, value) in "\(key): \(value)\n"
                }.joined(separator: "\n") ?? ""
            return "\(statusCode)\n"
                + "\(headers)\n"
                + "\(String(data: body, encoding: String.Encoding.utf8)!)\n"
        }
    }

}
