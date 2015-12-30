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
        let components = NSURLComponents(string: httpRequest.url)
        components?.queryItems = httpRequest.parameters?.map {
            NSURLQueryItem(name: $0.0, value: $0.1)
        }
        let request = NSMutableURLRequest(URL: components?.URL ?? NSURL())
        request.HTTPMethod = httpRequest.httpMethod.rawValue
        request.HTTPBody = httpRequest.body
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request) { data, response, error in
            if let error = error {
                promise.failure(error)
            } else if let response = response as? NSHTTPURLResponse, let data = data {
                let response = self.mapNSHTTPURlResponseToHTTPResponse(response, data: data)
                promise.success(response)
            }
        }.resume()
        return promise.future
    }

    private func mapNSHTTPURlResponseToHTTPResponse(response: NSHTTPURLResponse, data: NSData) -> HTTPResponse {
        let statusCode = response.statusCode
        let headers = response.allHeaderFields.map {
            (key, value) in (key as! String, value as! String)
        }
        return HTTPResponse(statusCode: statusCode, headers: Dictionary(headers), body: data)
    }
}
