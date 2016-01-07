//
//  NSHTTPClient.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Result

public class NSHTTPClient: HTTPClient {

    public func send(httpRequest: HTTPRequest, completion: (Result<HTTPResponse, BothamAPIClientError>) -> ()) {
        let request = mapHTTPRequestToNSURLRequest(httpRequest)
        let session = NSURLSession.sharedSession()
        session.configuration.timeoutIntervalForRequest = timeout
        session.configuration.timeoutIntervalForResource = timeout
        session.dataTaskWithRequest(request) { data, response, error in
            if let error = error {
                let bothamError = self.mapNSErrorToBothamError(error)
                completion(Result.Failure(bothamError))
            } else if let response = response as? NSHTTPURLResponse, let data = data {
                let response = self.mapNSHTTPURlResponseToHTTPResponse(response, data: data)
                completion(Result.Success(response))
            }
        }.resume()
    }

    private func mapHTTPRequestToNSURLRequest(httpRequest: HTTPRequest) -> NSURLRequest {
        let components = NSURLComponents(string: httpRequest.url)
        if let params = httpRequest.parameters {
            components?.queryItems = params.map { (key, value) in
                return NSURLQueryItem(name: key, value: value)
            }
        }
        let request = NSMutableURLRequest(URL: components?.URL ?? NSURL())
        request.allHTTPHeaderFields = httpRequest.headers
        request.HTTPMethod = httpRequest.httpMethod.rawValue
        request.HTTPBody = httpRequest.encodedBody
        request.timeoutInterval = timeout
        return request
    }

    private func mapNSHTTPURlResponseToHTTPResponse(response: NSHTTPURLResponse,
        data: NSData) -> HTTPResponse {
        let statusCode = response.statusCode
        let headers = response.allHeaderFields.map {
            (key, value) in (key as! String, value as! String)
        }
        return HTTPResponse(statusCode: statusCode,
            headers: CaseInsensitiveDictionary(dictionary: Dictionary(headers)),
            body: data)
    }

}
