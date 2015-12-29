//
//  NSHTTPClient.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import BrightFutures

class NSHTTPClient: HTTPClient {

    func send(httpRequest: HTTPRequest) -> Future<HTTPResponse, NSError> {
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
            let encodingError = error as NSError
            promise.failure(encodingError)
        }
        return promise.future
    }

    private func mapHTTPRequestToNSURLRequest(httpRequest: HTTPRequest) throws -> NSURLRequest {
        let components = NSURLComponents(string: httpRequest.url)
        components?.queryItems = httpRequest.parameters?.map {
            NSURLQueryItem(name: $0.0, value: $0.1 as? String)
        }
        let request = NSMutableURLRequest(URL: components?.URL ?? NSURL())
        request.HTTPMethod = httpRequest.httpMethod.rawValue
        let encodedBody = try HTTPEncoder.encodeBody(httpRequest)
        request.HTTPBody = encodedBody
        return request
    }
}
