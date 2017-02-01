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

class HTTPRequestTests: XCTestCase {

    private let anyURL = "http://www.karumi.com"
    private let anyHTTPMethod = HTTPMethod.GET
    private let anyParams = ["x":"y"]
    private let anyHeaders = ["x":"y"]

    func testShouldReplaceRequestURL() {
        var request = givenAnHTTPRequest("http://www.karumi.com")

        request = request.withURL("http://blog.karumi.com")

        expect(request.url).to(equal("http://blog.karumi.com"))
    }

    func testShouldReplaceRequestParameters() {
        var request = givenAnHTTPRequest(parameters: anyParams)

        request = request.withParameters(["a":"b"])

        expect(request.parameters?.count).to(equal(1))
        expect(request.parameters?["a"]!).to(equal("b"))
    }

    func testShouldReplaceRequestHeaders() {
        var request = givenAnHTTPRequest(headers: anyHeaders)

        request = request.withHeaders(["a":"b"])

        expect(request.headers?.count).to(equal(1))
        expect(request.headers?["a"]).to(equal("b"))
    }

    func testShouldReplaceRequestHTTPMethod() {
        var request = givenAnHTTPRequest(httpMethod: .GET)

        request = request.withHTTPMethod(.POST)

        expect(request.httpMethod).to(equal(HTTPMethod.POST))
    }

    func testShouldReplaceRequestBody() {
        var request = givenAnHTTPRequest(body: Data() as NSData?)

        request = request.withBody(["a":"b" as AnyObject])

        expect(request.body?["a"] as? String).to(equal("b"))
    }

    private func givenAnEmptyHTTPRequest() -> HTTPRequest {
        return HTTPRequest(
            url: anyURL,
            parameters: [String:String](),
            headers: nil,
            httpMethod: anyHTTPMethod,
            body: nil)
    }

    func testShouldAddHeadersWhenTheOriginalRequestIsEmpty() {
        var request = givenAnEmptyHTTPRequest()

        request = request.appendingHeaders(["a":"b"])

        expect(request.headers?.count).to(equal(1))
        expect(request.headers?["a"]).to(equal("b"))
    }

    func testShouldAddHeadersWhenTheRequestAlreadyHaveRequests() {
        var request = givenAnHTTPRequest(headers:["key":"value"])

        request = request.appendingHeaders(["a":"b"])

        expect(request.headers?.count).to(equal(2))
        expect(request.headers?["key"]).to(equal("value"))
        expect(request.headers?["a"]).to(equal("b"))
    }

    func testShouldAddParametersWhenTheOriginalRequestIsEmpty() {
        var request = givenAnEmptyHTTPRequest()

        request = request.appendingParameters(["a":"b"])

        expect(request.parameters?.count).to(equal(1))
        expect(request.parameters?["a"]!).to(equal("b"))
    }

    func testShouldAddParametersWhenTheRequestAlreadyHaveRequests() {
        var request = givenAnHTTPRequest(parameters:["key":"value"])

        request = request.appendingParameters(["a":"b"])

        expect(request.parameters?.count).to(equal(2))
        expect(request.parameters?["key"]!).to(equal("value"))
        expect(request.parameters?["a"]!).to(equal("b"))
    }

    private func givenAnHTTPRequest(_ url: String = "http://www.karumi.com",
        parameters: [String:String]? = nil,
        headers: [String:String]? = nil,
        httpMethod: HTTPMethod = .GET,
        body: NSData? = nil ) -> HTTPRequest {
        return HTTPRequest(
            url: url,
            parameters: parameters,
            headers: headers,
            httpMethod: httpMethod,
            body: nil)
    }
}
