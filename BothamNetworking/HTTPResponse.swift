//
//  HTTPResponse.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

public struct HTTPResponse {

    public let statusCode: Int
    public let body: NSData

    public func withStatusCode(statusCode: Int) -> HTTPResponse {
        return HTTPResponse(
            statusCode: statusCode,
            body: body)
    }

    public func withBody(body: NSData) -> HTTPResponse {
        return HTTPResponse(
            statusCode: statusCode,
            body: body)
    }

}