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

    func testEncodesBodyUsingJsonEncodingByDefaultIfTheRequestDoesNotContainsContentTypeHeader() {
        let request = givenAHTTPRequestWith(body: ["a":"b"])

        let bodyNSData = try! HTTPEncoder.encodeBody(request)
        let bodyString = String(data: bodyNSData!, encoding: NSUTF8StringEncoding)

        expect(bodyString).to(equal("{\"a\":\"b\"}"))
    }

    func testEncodesBodyUsingJsonEncodingIfTheRequestContainsJsonContentTypeHeader() {
        let request = givenAHTTPRequestWith(headers: ["Content-Type":"application/json"], body: ["a":"b"])

        let bodyNSData = try! HTTPEncoder.encodeBody(request)
        let bodyString = String(data: bodyNSData!, encoding: NSUTF8StringEncoding)

        expect(bodyString).to(equal("{\"a\":\"b\"}"))
    }

    func testEncodesParamsUsingFormEncodingIfTheRequestContainsFormContentTypeHeader() {
        let request = givenAHTTPRequestWith(headers: ["Content-Type":"application/x-www-form-urlencoded"],
            parameters: ["a":"b","c":3])

        let bodyNSData = try! HTTPEncoder.encodeBody(request)
        let bodyString = String(data: bodyNSData!, encoding: NSUTF8StringEncoding)

        expect(bodyString).to(equal("a=b&c=3"))
    }

    private func givenAHTTPRequestWith(
        headers headers: [String:String]? = nil,
        parameters: [String: AnyObject]? = nil,
        body: [String: AnyObject]? = nil) -> HTTPRequest {
        return HTTPRequest(
            url: "http://www.karumi.com",
            parameters: parameters,
            headers: headers,
            httpMethod: .GET,
            body: body)
    }

}

