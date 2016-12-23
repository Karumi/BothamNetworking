//
//  NSHTTPClientTests.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

import Foundation
import XCTest
import Nocilla
import Nimble
import Result
@testable import BothamNetworking

class NSHTTPClientTests: NocillaTestCase {

    fileprivate let anyUrl = "http://www.any.com"
    fileprivate let anyStatusCode = 201
    fileprivate let anyBody = "{HttpResponseBody = true}"
    fileprivate let anyNSError = NSError(domain: "DomainError", code: 123, userInfo: nil)

    func testSendsGetRequestToAnyPath() {
        stubRequest("GET", anyUrl as LSMatcheable!)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsPostRequestToAnyPath() {
        stubRequest("POST", anyUrl as LSMatcheable!)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.POST, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsPutRequestToAnyPath() {
        stubRequest("PUT", anyUrl as LSMatcheable!)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.PUT, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsDeleteRequestToAnyPath() {
        stubRequest("DELETE", anyUrl as LSMatcheable!)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.DELETE, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsHeadRequestToAnyPath() {
        stubRequest("HEAD", anyUrl as LSMatcheable!)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.HEAD, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testReceivesHttpStatusCodeInTheHttpResponse() {
        stubRequest("GET", anyUrl as LSMatcheable!).andReturn(anyStatusCode)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testPropagatesErrorsInTheFuture() {
        stubRequest("GET", anyUrl as LSMatcheable!).andFailWithError(anyNSError)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(failWithError(.httpClientError(error: anyNSError)))
    }

    func testSendsParamsConfiguredInTheHttpRequest() {
        stubRequest("GET", anyUrl + "?key=value" as NSString)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl, params: ["key" : "value"])

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsBodyConfiguredInTheHttpRequest() {
        stubRequest("POST", anyUrl as LSMatcheable!)
            .withBody("{\"key\":\"value\"}" as NSString)
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.POST, url: anyUrl, body: ["key" : "value" as AnyObject])

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testReturnsNSConnectionErrorsAsABothamAPIClientNetworkError() {
        stubRequest("GET", anyUrl as LSMatcheable!).andFailWithError(NSError.anyConnectionError())
        let httpClient = NSHTTPClient()
        let request = givenOneHttpRequest(.GET, url: anyUrl)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        httpClient.send(request) { result in
            response = result
        }

        expect(response).toEventually(failWithError(.networkError))
    }

    fileprivate func givenOneHttpRequest(_ httpMethod: HTTPMethod,
        url: String, params: [String:String]? = nil,
        headers: [String:String]? = nil,
        body: [String:AnyObject]? = nil) -> HTTPRequest {
            var headers = headers
            headers += ["Content-Type":"application/json"]
            return HTTPRequest(url: url, parameters: params, headers: headers, httpMethod: httpMethod, body: body)
    }

}

extension NSError {

    static func anyConnectionError() -> NSError {
        return NSError(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost, userInfo: nil)
    }

}
