//
//  HTTPRequestTests.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 29/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import XCTest
import Nimble
@testable import BothamNetworking

class HTTPRequestTests : XCTestCase {

    private let anyURL = "http://www.karumi.com"
    private let anyHTTPMethod = HTTPMethod.GET

    func testShouldAddHeadersWhenTheOriginalRequestIsEmpty() {
        var request = givenAnEmptyHTTPRequest()

        request = request.addHeaders(["a":"b"])

        expect(request.headers?.count).to(equal(1))
        expect(request.headers?["a"]).to(equal("b"))
    }

    func testShouldAddHeadersWhenTheRequestAlreadyHaveRequests() {
        var request = givenAnHTTPRequest(["key":"value"])

        request = request.addHeaders(["a":"b"])

        expect(request.headers?.count).to(equal(2))
        expect(request.headers?["key"]).to(equal("value"))
        expect(request.headers?["a"]).to(equal("b"))
    }

    private func givenAnEmptyHTTPRequest() -> HTTPRequest {
        return HTTPRequest(
            url: anyURL,
            parameters: nil,
            headers: nil,
            httpMethod: anyHTTPMethod,
            body: nil)
    }

    private func givenAnHTTPRequest(headers: [String:String]) -> HTTPRequest {
        return HTTPRequest(
            url: anyURL,
            parameters: nil,
            headers: headers,
            httpMethod: anyHTTPMethod,
            body: nil)
    }
}