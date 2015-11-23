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

    func send(httpRequest: HTTPRequest) -> Future<HTTPResponse, BothamError> {
        let promise = Promise<HTTPResponse, BothamError>()
        let components = NSURLComponents(string: httpRequest.url)
        components?.queryItems = httpRequest.parameters?.map {
            NSURLQueryItem(name: $0.0, value: $0.1)
        }
        let request = NSMutableURLRequest(URL: components?.URL ?? NSURL())
        request.HTTPMethod = httpRequest.httpMethod.rawValue
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request) { data, response, error in
            if let error = error {
                promise.failure(BothamError.UnkownError(error: error))
            } else if let response = response as? NSHTTPURLResponse, let data = data {
                let statusCode = response.statusCode
                let response = HTTPResponse(statusCode: statusCode, body: data)
                promise.success(response)
            }
        }.resume()
        return promise.future
    }
}
