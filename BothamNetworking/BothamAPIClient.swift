//
//  BothamAPIClient.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import BrightFutures

public class BothamAPIClient {

    let baseEndpoint: String
    let httpClient: HTTPClient

    init(baseEndpoint: String, httpClient: HTTPClient) {
        self.baseEndpoint = baseEndpoint
        self.httpClient = httpClient
    }

    public func GET(path: String, parameters: [String:String]? = nil, headers: [String:String]? = nil) -> Future<HTTPResponse, BothamError> {
        return sendRequest(.GET, path: path, params: parameters, headers: headers)
    }

    public func POST(path: String, parameters: [String:String]? = nil, headers: [String:String]? = nil, body: [String: AnyObject]? = nil) -> Future<HTTPResponse, BothamError> {
        return sendRequest(.POST, path: path, params: parameters, headers: headers, body: body)
    }

    public func PUT(path: String, parameters: [String:String]? = nil, headers: [String:String]? = nil, body: [String: AnyObject]? = nil) -> Future<HTTPResponse, BothamError> {
        return sendRequest(.PUT, path: path, params: parameters, headers: headers, body: body)
    }

    public func DELETE(path: String, parameters: [String:String]? = nil, headers: [String:String]? = nil, body: [String: AnyObject]? = nil) -> Future<HTTPResponse, BothamError> {
        return sendRequest(.DELETE, path: path, params: parameters, headers: headers, body: body)
    }

    public func PATCH(path: String, parameters: [String:String]? = nil, headers: [String:String]? = nil, body: [String: AnyObject]? = nil) -> Future<HTTPResponse, BothamError> {
        return sendRequest(.PATCH, path: path, params: parameters, headers: headers, body: body)
    }

    func sendRequest(httpMethod: HTTPMethod, path: String,
        params: [String:String]? = nil,
        headers: [String:String]? = nil,
        body: [String:AnyObject]? = nil) -> Future<HTTPResponse, BothamError> {
            let request = HTTPRequest(
                url: baseEndpoint + path,
                parameters: params,
                headers: headers,
                httpMethod: httpMethod,
                body: NSKeyedArchiver.archivedDataWithRootObject(body ?? NSData()))
            return httpClient.send(request)
                .mapError { return BothamError.UnkownError(error: $0) }
                .flatMap { httpResponse -> Future<HTTPResponse, BothamError> in
                    if 200..<300 ~= httpResponse.statusCode {
                        return Future(value: httpResponse)
                    } else {
                        let statusCode = httpResponse.statusCode
                        let body = httpResponse.body
                        return Future(error: BothamError.HTTPResponseError(statusCode: statusCode, body: body))
                    }
            }
    }
}