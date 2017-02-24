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

    public func send(_ httpRequest: HTTPRequest, completion: @escaping (Result<HTTPResponse, BothamAPIClientError>) -> ()) {
        guard let request = mapHTTPRequestToNSURLRequest(httpRequest) else {
            completion(Result.failure(.unsupportedURLScheme))
            return
        }

        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = timeout
        session.configuration.timeoutIntervalForResource = timeout
        session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                let bothamError = self.mapNSErrorToBothamError(error as NSError)
                completion(Result.failure(bothamError))
            } else if let response = response as? HTTPURLResponse, let data = data {
                let response = self.mapNSHTTPURlResponseToHTTPResponse(response, data: data)
                completion(Result.success(response))
            }
        }).resume()
    }

    private func mapHTTPRequestToNSURLRequest(_ httpRequest: HTTPRequest) -> URLRequest? {
        guard let url = mapHTTPRequestURL(httpRequest) else {
            return nil
        }

        let request = NSMutableURLRequest(url: url)
        request.allHTTPHeaderFields = httpRequest.headers
        request.httpMethod = httpRequest.httpMethod.rawValue
        request.httpBody = httpRequest.encodedBody
        request.timeoutInterval = timeout
        return request as URLRequest
    }

    private func mapHTTPRequestURL(_ httpRequest: HTTPRequest) -> URL? {
        guard var components = URLComponents(string: httpRequest.url) else {
            return nil
        }

        if let params = httpRequest.parameters {
            components.queryItems = params.map { (key, value) in
                return URLQueryItem(name: key, value: value)
            }
        }

        return components.url
    }

    private func mapNSHTTPURlResponseToHTTPResponse(_ response: HTTPURLResponse,
        data: Data) -> HTTPResponse {
        let statusCode = response.statusCode
        let headers = response.allHeaderFields.map {
            (key, value) in (key as! String, value as! String)
        }
        return HTTPResponse(
            statusCode: statusCode,
            headers: CaseInsensitiveDictionary(dictionary: Dictionary(headers)),
            body: data)
    }

}
