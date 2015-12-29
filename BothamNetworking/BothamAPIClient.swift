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

    static var globalRequestInterceptors = [BothamRequestInterceptor]()
    static var globalResponseInterceptors = [BothamResponseInterceptor]()

    let baseEndpoint: String
    let httpClient: HTTPClient

    var requestInterceptors: [BothamRequestInterceptor]
    var responseInterceptors: [BothamResponseInterceptor]

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

    public func addRequestInterceptor(interceptor: BothamRequestInterceptor) {
        addRequestInterceptors([interceptor])
    }

    public func addRequestInterceptors(interceptors: [BothamRequestInterceptor]) {
        requestInterceptors.appendContentsOf(interceptors)
    }

    public func removeRequestInterceptors() {
        requestInterceptors.removeAll()
    }

    public static func addGlobalRequestInterceptor(interceptor: BothamRequestInterceptor) {
        addGlobalRequestInterceptors([interceptor])
    }

    public static func addGlobalRequestInterceptors(interceptors: [BothamRequestInterceptor]) {
        BothamAPIClient.globalRequestInterceptors.appendContentsOf(interceptors)
    }

    public static func removeGlobalRequestInterceptors() {
        BothamAPIClient.globalRequestInterceptors.removeAll()
    }

    public func addResponseInterceptor(interceptor: BothamResponseInterceptor) {
        addResponseInterceptors([interceptor])
    }

    public func addResponseInterceptors(interceptors: [BothamResponseInterceptor]) {
        responseInterceptors.appendContentsOf(interceptors)
    }

    public func removeResponseInterceptors() {
        responseInterceptors.removeAll()
    }
    public static func addGlobalResponseInterceptor(interceptor: BothamResponseInterceptor) {
        addGlobalResponseInterceptors([interceptor])
    }

    public static func addGlobalResponseInterceptors(interceptors: [BothamResponseInterceptor]) {
        BothamAPIClient.globalResponseInterceptors.appendContentsOf(interceptors)
    }

    public static func removeGlobalResponseInterceptors() {
        BothamAPIClient.globalResponseInterceptors.removeAll()
    }

    func sendRequest(httpMethod: HTTPMethod, path: String,
        params: [String:String]? = nil,
        headers: [String:String]? = nil,
        body: [String:AnyObject]? = nil) -> Future<HTTPResponse, BothamAPIClientError> {

            var request = HTTPRequest(
                url: baseEndpoint + path,
                parameters: params,
                headers: headers,
                httpMethod: httpMethod,
                body: NSKeyedArchiver.archivedDataWithRootObject(body ?? NSData()))

            request = notifyRequestInterceptors(request)

            return httpClient.send(request)
                .mapError { return .HTTPClientError(error: $0) }
                .flatMap { httpResponse -> Future<HTTPResponse, BothamAPIClientError> in
                    return self.mapHTTPResponseToBothamAPIClientError(httpResponse)
                }
                .map { self.notifyResponseInterceptors($0) }
    }

    private func notifyRequestInterceptors(request: HTTPRequest) -> HTTPRequest {
        var interceptedRequest = request
        requestInterceptors.forEach { interceptor in
            interceptedRequest = interceptor.intercept(interceptedRequest)
        }
        BothamAPIClient.globalRequestInterceptors.forEach { interceptor in
            interceptedRequest = interceptor.intercept(interceptedRequest)
        }
        return interceptedRequest
    }

    private func notifyResponseInterceptors(response: HTTPResponse) -> HTTPResponse {
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