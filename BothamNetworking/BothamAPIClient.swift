//
//  BothamAPIClient.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Result

public class BothamAPIClient {

    public static var globalRequestInterceptors = [BothamRequestInterceptor]()
    public static var globalResponseInterceptors = [BothamResponseInterceptor]()

    public var requestInterceptors: [BothamRequestInterceptor]
    public var responseInterceptors: [BothamResponseInterceptor]

    let baseEndpoint: String
    let httpClient: HTTPClient

    public init(baseEndpoint: String, httpClient: HTTPClient = NSHTTPClient()) {
        self.baseEndpoint = baseEndpoint
        self.httpClient = httpClient
        self.requestInterceptors = [BothamRequestInterceptor]()
        self.responseInterceptors = [BothamResponseInterceptor]()
    }

    public func GET(path: String, parameters: [String:String?]? = nil,
        headers: [String:String]? = nil,
        callback: (Result<HTTPResponse, BothamAPIClientError>) -> ()) {
            return sendRequest(.GET, path: path, params: parameters, headers: headers, callback: callback)
    }

    public func POST(path: String, parameters: [String:String?]? = nil,
        headers: [String:String]? = nil,
        body: [String: AnyObject]? = nil,
        callback: (Result<HTTPResponse, BothamAPIClientError>) -> ()) {
        return sendRequest(.POST, path: path, params: parameters, headers: headers, body: body, callback: callback)
    }

    public func PUT(path: String, parameters: [String:String?]? = nil,
        headers: [String:String]? = nil,
        body: [String: AnyObject]? = nil,
        callback: (Result<HTTPResponse, BothamAPIClientError>) -> ()) {
        return sendRequest(.PUT, path: path, params: parameters, headers: headers, body: body, callback: callback)
    }

    public func DELETE(path: String, parameters: [String:String?]? = nil,
        headers: [String:String]? = nil,
        body: [String: AnyObject]? = nil,
        callback: (Result<HTTPResponse, BothamAPIClientError>) -> ()) {
        return sendRequest(.DELETE, path: path, params: parameters, headers: headers, body: body, callback: callback)
    }

    public func PATCH(path: String, parameters: [String:String?]? = nil,
        headers: [String:String]? = nil,
        body: [String: AnyObject]? = nil,
        callback: (Result<HTTPResponse, BothamAPIClientError>) -> ()) {
        return sendRequest(.PATCH, path: path, params: parameters, headers: headers, body: body, callback: callback)
    }

    func sendRequest(httpMethod: HTTPMethod, path: String,
        params: [String:String?]? = nil,
        headers: [String:String]? = nil,
        body: [String:AnyObject]? = nil,
        callback: (Result<HTTPResponse, BothamAPIClientError>) -> ()) {

            let initialRequest = HTTPRequest(
                url: baseEndpoint + path,
                parameters: params,
                headers: headers,
                httpMethod: httpMethod,
                body: body)

            let interceptedRequest = applyRequestInterceptors(initialRequest)
            if !hasValidScheme(interceptedRequest) {
                callback(Result.Failure(BothamAPIClientError.UnsupportedURLScheme))
            } else {
                return httpClient.send(interceptedRequest) { result in
                    result.mapError { BothamAPIClientError.HTTPClientError(error: $0) }
                        .map { return self.applyResponseInterceptors($0) }
                        .flatMap { httpResponse -> Result<HTTPResponse, BothamAPIClientError> in
                            return self.mapHTTPResponseToBothamAPIClientError(httpResponse)
                    }
                }
            }
    }


    private func applyRequestInterceptors(request: HTTPRequest) -> HTTPRequest {
        var interceptedRequest = request
        requestInterceptors.forEach { interceptor in
            interceptedRequest = interceptor.intercept(interceptedRequest)
        }
        BothamAPIClient.globalRequestInterceptors.forEach { interceptor in
            interceptedRequest = interceptor.intercept(interceptedRequest)
        }
        return interceptedRequest
    }

    private func applyResponseInterceptors(response: HTTPResponse) -> HTTPResponse {
        var interceptedResponse = response
        responseInterceptors.forEach { interceptor in
            interceptedResponse = interceptor.intercept(interceptedResponse)
        }
        BothamAPIClient.globalResponseInterceptors.forEach { interceptor in
            interceptedResponse = interceptor.intercept(interceptedResponse)
        }
        return interceptedResponse
    }

    private func mapHTTPResponseToBothamAPIClientError(httpResponse: HTTPResponse)
        -> Result<HTTPResponse, BothamAPIClientError> {
            if isValidResponse(httpResponse) {
                return Result.Success(httpResponse)
            } else {
                let statusCode = httpResponse.statusCode
                let body = httpResponse.body
                return Result.Failure(.HTTPResponseError(statusCode: statusCode, body: body))
            }
    }

    private func isValidResponse(response: HTTPResponse) -> Bool {
        return httpClient.isValidResponse(response)
    }

    private func hasValidScheme(request: HTTPRequest) -> Bool {
        return httpClient.hasValidScheme(request)

    }
}