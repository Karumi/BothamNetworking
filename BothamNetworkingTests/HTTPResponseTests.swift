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

    private let anyHeaders = ["x":"y"]

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

    func testShouldReplaceResponseHeaders() {
        var response = givenAResponse(headers: anyHeaders)

        response = response.withHeaders(["a":"b"])

        expect(response.headers?.count).to(equal(1))
        expect(response.headers?["a"]).to(equal("b"))
    }

    func testShouldAppendHeadersWhenTheOriginalResponseIsEmpty() {
        var response = givenAResponse()

        response = response.appendHeaders(["a":"b"])

        expect(response.headers?.count).to(equal(1))
        expect(response.headers?["a"]).to(equal("b"))
    }

    func testShouldAppendHeadersWhenTheResponseAlreadyHaveHeaders() {
        var response = givenAResponse(headers:["key":"value"])

        response = response.appendHeaders(["a":"b"])

        expect(response.headers?.count).to(equal(2))
        expect(response.headers?["key"]).to(equal("value"))
        expect(response.headers?["a"]).to(equal("b"))
    }

    private func givenAResponse(statusCode: Int = 200,
        headers: [String:String]? = nil,
        body: NSData = NSData()) -> HTTPResponse {
            return HTTPResponse(statusCode: statusCode, headers: CaseInsensitiveDictionary(dictionary: headers ?? [ : ]), body: body)
    }

}