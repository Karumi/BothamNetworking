//
//  HTTPClient.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

import Foundation
import BrightFutures

public protocol HTTPClient {

    func send(httpRequest: HTTPRequest) -> Future<HTTPResponse, NSError>

    func hasValidScheme(httpRequest: HTTPRequest) -> Bool

    func isValidResponse(httpRespone: HTTPResponse) -> Bool

}