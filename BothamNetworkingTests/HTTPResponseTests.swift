//
//  HTTPResponseTests.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 29/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import XCTest
import Nimble
@testable import BothamNetworking

class HTTPResponseTests: XCTestCase {

    func testShouldReplaceResponseStatusCode() {
        var response = givenAResponse(200)

        response = response.withStatusCode(201)

        expect(response.statusCode).to(equal(201))
    }

    func testShouldReplaceResponseBody() {
        var response = givenAResponse(body: NSData())

        let newBody = NSData()
        response = response.withBody(newBody)

        expect(response.body).to(equal(newBody))
    }

    private func givenAResponse(statusCode: Int = 200, body: NSData = NSData()) -> HTTPResponse {
        return HTTPResponse(statusCode: statusCode, body: body)
    }

}