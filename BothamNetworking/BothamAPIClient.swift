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

    public func GET(_ path: String, parameters: [String:String]? = nil,
        headers: [String:String]? = nil, completion: ((Result<HTTPResponse, BothamAPIClientError>) -> ())? = nil) {
        return sendRequest(.GET, path: path, params: parameters, headers: headers, completion: completion)
    }

    public func POST(_ path: String, parameters: [String:String]? = nil,
        headers: [String:String]? = nil,
        body: [String: AnyObject]? = nil,
        completion: ((Result<HTTPResponse, BothamAPIClientError>) -> ())? = nil) {
        return sendRequest(.POST, path: path, params: parameters, headers: headers,
            body: body, completion: completion)
    }

    public func PUT(_ path: String, parameters: [String:String]? = nil,
        headers: [String:String]? = nil,
        body: [String: AnyObject]? = nil,
        completion: ((Result<HTTPResponse, BothamAPIClientError>) -> ())? = nil) {
        return sendRequest(.PUT, path: path, params: parameters, headers: headers,
            body: body, completion: completion)
    }

    public func DELETE(_ path: String, parameters: [String:String]? = nil,
        headers: [String:String]? = nil,
        body: [String: AnyObject]? = nil,
        completion: ((Result<HTTPResponse, BothamAPIClientError>) -> ())? = nil) {
        return sendRequest(.DELETE, path: path, params: parameters, headers: headers,
            body: body, completion: completion)
    }

    public func PATCH(_ path: String, parameters: [String:String]? = nil,
        headers: [String:String]? = nil,
        body: [String: AnyObject]? = nil,
        completion: ((Result<HTTPResponse, BothamAPIClientError>) -> ())? = nil) {
        return sendRequest(.PATCH, path: path, params: parameters, headers: headers,
                body: body, completion: completion)
    }

    func sendRequest(_ httpMethod: HTTPMethod, path: String,
        params: [String:String]? = nil,
        headers: [String:String]? = nil,
        body: [String:AnyObject]? = nil,
        completion: ((Result<HTTPResponse, BothamAPIClientError>) -> ())? = nil) {

            let initialRequest = HTTPRequest(
                url: baseEndpoint + path,
                parameters: params,
                headers: headers,
                httpMethod: httpMethod,
                body: body)

            let interceptedRequest = applyRequestInterceptors(initialRequest)
            if !hasValidScheme(interceptedRequest) {
                completion?(Result.failure(BothamAPIClientError.unsupportedURLScheme))
            } else {
                send(request: interceptedRequest) { result in
                    if let error = result.error, case .retry = error {
                        self.sendRequest(httpMethod,
                            path: path,
                            params: params,
                            headers: headers,
                            body: body,
                            completion: completion)
                    } else {
                        completion?(result)
                    }
                }
            }
    }

    private func send(request: HTTPRequest, completion: ((Result<HTTPResponse, BothamAPIClientError>) -> ())? = nil) {
        httpClient.send(request) { result in
            if let _ = result.error {
                completion?(result)
            } else if let response = result.value {
                self.applyResponseInterceptors(response) { interceptorResult in
                    let mappedResult = interceptorResult.flatMap { httpResponse in
                        return self.mapHTTPResponseToBothamAPIClientError(httpResponse)
                    }
                    completion?(mappedResult)
                }
            }
        }
    }

    private func applyRequestInterceptors(_ request: HTTPRequest) -> HTTPRequest {
        var interceptedRequest = request
        let interceptors = requestInterceptors + BothamAPIClient.globalRequestInterceptors
        interceptors.forEach { interceptor in
            interceptedRequest = interceptor.intercept(interceptedRequest)
        }
        return interceptedRequest
    }

    private func applyResponseInterceptors(_ response: HTTPResponse,
        completion: (Result<HTTPResponse, BothamAPIClientError>) -> Void) {
            let interceptors = responseInterceptors + BothamAPIClient.globalResponseInterceptors
            applyResponseInterceptors(interceptors, response: response, completion: completion)
    }

    private func applyResponseInterceptors(_ interceptors: [BothamResponseInterceptor],
        response: HTTPResponse,
        completion: (Result<HTTPResponse, BothamAPIClientError>) -> Void) {
            if interceptors.isEmpty {
                completion(Result.success(response))
            } else {
                interceptors[0].intercept(response) { result in
                    if let response = result.value {
                        self.applyResponseInterceptors(Array(interceptors.dropFirst()),
                            response: response, completion: completion)
                    } else {
                        completion(result)
                    }
                }
            }
    }

    private func mapHTTPResponseToBothamAPIClientError(_ httpResponse: HTTPResponse)
        -> Result<HTTPResponse, BothamAPIClientError> {
            if isValid(response: httpResponse) {
                return Result.success(httpResponse)
            } else {
                let statusCode = httpResponse.statusCode
                let body = httpResponse.body
                return Result.failure(.httpResponseError(statusCode: statusCode, body: body))
            }
    }

    private func isValid(response: HTTPResponse) -> Bool {
        return httpClient.isValidResponse(response)
    }

    private func hasValidScheme(_ request: HTTPRequest) -> Bool {
        return httpClient.hasValidScheme(request)
    }
}
