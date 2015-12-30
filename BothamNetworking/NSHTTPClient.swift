//
//  NSHTTPClient.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import BrightFutures

public class NSHTTPClient: HTTPClient {

    public func send(httpRequest: HTTPRequest) -> Future<HTTPResponse, NSError> {
        let promise = Promise<HTTPResponse, NSError>()
        do {
            let request = try mapHTTPRequestToNSURLRequest(httpRequest)
            let session = NSURLSession.sharedSession()
            session.dataTaskWithRequest(request) { data, response, error in
                if let error = error {
                    promise.failure(error)
                } else if let response = response as? NSHTTPURLResponse, let data = data {
                    let statusCode = response.statusCode
                    let response = HTTPResponse(statusCode: statusCode, body: data)
                    promise.success(response)
                }
            }.resume()
        } catch {
            promise.failure(error as NSError)
        }
        return promise.future
    }

    public func encodeRequestBody(request: HTTPRequest) throws -> NSData? {
        return try HTTPEncoder.encodeBody(request)
    }

    private func mapHTTPRequestToNSURLRequest(httpRequest: HTTPRequest) throws -> NSURLRequest {
        let components = NSURLComponents(string: httpRequest.url)
        if let params = httpRequest.parameters {
            components?.queryItems = params.map {
                NSURLQueryItem(name: $0.0, value: $0.1)
            }
        }
        let request = NSMutableURLRequest(URL: components?.URL ?? NSURL())
        request.HTTPMethod = httpRequest.httpMethod.rawValue
        let encodedBody = try encodeRequestBody(httpRequest)
        request.HTTPBody = encodedBody
        return request
    }
}
