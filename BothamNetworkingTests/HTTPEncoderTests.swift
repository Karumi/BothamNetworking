//
//  HTTPEncoderTests.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 29/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import XCTest
import Nimble
@testable import BothamNetworking

class HTTPEncoderTests: XCTestCase {

    func testDoesNotEncodesBodyIfTheRequestDoesNotContainsContentTypeHeader() {
        let request = givenAHTTPRequestWith(body: ["a":"b" as AnyObject])

        let bodyNSData = HTTPEncoder.encodeBody(request)

        expect(bodyNSData).to(beNil())
    }

    func testEncodesBodyUsingJsonEncodingIfTheRequestContainsJsonContentTypeHeader() {
        let request = givenAHTTPRequestWith(headers: ["Content-Type":"application/json"], body: ["a":"b" as AnyObject])

        let bodyNSData = HTTPEncoder.encodeBody(request)
        let bodyString = String(data: bodyNSData!, encoding: String.Encoding.utf8)

        expect(bodyString).to(equal("{\"a\":\"b\"}"))
    }

    func testEncodesParamsUsingFormEncodingIfTheRequestContainsFormContentTypeHeader() {
        let request = givenAHTTPRequestWith(headers: ["Content-Type":"application/x-www-form-urlencoded"],
            body: ["a":"b" as AnyObject,"c":3 as AnyObject])

        let bodyNSData = HTTPEncoder.encodeBody(request)
        let bodyString = String(data: bodyNSData!, encoding: String.Encoding.utf8)

        expect(bodyString).to(equal("a=b&c=3"))
    }

    fileprivate func givenAHTTPRequestWith(
        headers: [String:String]? = nil,
        parameters: [String: String]? = nil,
        body: [String: AnyObject]? = nil) -> HTTPRequest {
        return HTTPRequest(
            url: "http://www.karumi.com",
            parameters: parameters,
            headers: headers,
            httpMethod: .GET,
            body: body)
    }

}

