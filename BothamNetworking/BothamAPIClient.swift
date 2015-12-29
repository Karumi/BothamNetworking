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

    public static var globalRequestInterceptors = [BothamRequestInterceptor]()
    public static var globalResponseInterceptors = [BothamResponseInterceptor]()

    public var requestInterceptors: [BothamRequestInterceptor]
    public var responseInterceptors: [BothamResponseInterceptor]

    let baseEndpoint: String
    let httpClient: HTTPClient

    init(baseEndpoint: String, httpClient: HTTPClient) {
        self.baseEndpoint = baseEndpoint
        self.httpClient = httpClient
        self.requestInterceptors = [BothamRequestInterceptor]()
        self.responseInterceptors = [BothamResponseInterceptor]()
    }

    public func GET(path: String, parameters: [String:String]? = nil, headers: [String:String]? = nil)
        -> Future<HTTPResponse, BothamAPIClientError> {
        return sendRequest(.GET, path: path, params: parameters, headers: headers)
    }

    public func POST(path: String, parameters: [String:String]? = nil, headers: [String:String]? = nil,
        body: [String: AnyObject]? = nil) -> Future<HTTPResponse, BothamAPIClientError> {
        return sendRequest(.POST, path: path, params: parameters, headers: headers, body: body)
    }

    public func PUT(path: String, parameters: [String:String]? = nil, headers: [String:String]? = nil,
        body: [String: AnyObject]? = nil) -> Future<HTTPResponse, BothamAPIClientError> {
        return sendRequest(.PUT, path: path, params: parameters, headers: headers, body: body)
    }

    public func DELETE(path: String, parameters: [String:String]? = nil, headers: [String:String]? = nil,
        body: [String: AnyObject]? = nil) -> Future<HTTPResponse, BothamAPIClientError> {
        return sendRequest(.DELETE, path: path, params: parameters, headers: headers, body: body)
    }

    public func PATCH(path: String, parameters: [String:String]? = nil, headers: [String:String]? = nil,
        body: [String: AnyObject]? = nil) -> Future<HTTPResponse, BothamAPIClientError> {
        return sendRequest(.PATCH, path: path, params: parameters, headers: headers, body: body)
    }

    func sendRequest(httpMethod: HTTPMethod, path: String,
        params: [String:String]? = nil,
        headers: [String:String]? = nil,
        body: [String:AnyObject]? = nil) -> Future<HTTPResponse, BothamAPIClientError> {

            let initialRequest = HTTPRequest(
                url: baseEndpoint + path,
                parameters: params,
                headers: headers,
                httpMethod: httpMethod,
                body: NSKeyedArchiver.archivedDataWithRootObject(body ?? NSData()))

            let interceptedRequest = applyRequestInterceptors(initialRequest)

            return httpClient.send(interceptedRequest)
                .mapError { return .HTTPClientError(error: $0) }
                .flatMap { httpResponse -> Future<HTTPResponse, BothamAPIClientError> in
                    return self.mapHTTPResponseToBothamAPIClientError(httpResponse)
                }
                .map { self.applyResponseInterceptors($0) }
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
        -> Future<HTTPResponse, BothamAPIClientError> {
        if 200..<300 ~= httpResponse.statusCode {
            return Future(value: httpResponse)
        } else {
            let statusCode = httpResponse.statusCode
            let body = httpResponse.body
            return Future(error: .HTTPResponseError(statusCode: statusCode, body: body))
        }
    }
}