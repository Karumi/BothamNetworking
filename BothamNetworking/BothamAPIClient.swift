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

    let baseEndpoint: String
    let httpClient: HTTPClient

    init(baseEndpoint: String, httpClient: HTTPClient) {
        self.baseEndpoint = baseEndpoint
        self.httpClient = httpClient
    }

    func sendRequest(httpMethod: HTTPMethod, path: String,
        params: [String:String]? = [String:String](),
        headers: [String:String]? = [String:String]()) -> Future<HTTPResponse, BothamError> {
            let request = HTTPRequest(
                url: baseEndpoint + path,
                parameters: params,
                headers: headers,
                httpMethod: httpMethod)
            return httpClient.send(request)
                .mapError {
                    print("-------------> \($0)")
                    return BothamError.UnkownError(error: $0)
                }
                .flatMap{ (httpResponse) -> Future<HTTPResponse, BothamError> in
                    if (httpResponse.statusCode == 400){
                        return Future(error: BothamError.HTTPResponseError(statusCode: 400, body: ""))
                    }else {
                        return Future(value: httpResponse)
                    }
            }
    }
}