//
//  ConnectionErrorHTTPClient.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 06/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation
import Result
@testable import BothamNetworking

class ConnectionErrorHTTPClient: HTTPClient {
    func send(httpRequest: HTTPRequest, completion: (Result<HTTPResponse, NSError>) -> ()) {
        let connectionError = NSError(domain: NSURLErrorDomain,
            code: NSURLErrorNotConnectedToInternet,
            userInfo: nil)
        completion(Result.Failure(connectionError))
    }
}
