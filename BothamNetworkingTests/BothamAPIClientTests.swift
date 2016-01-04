//
//  BothamAPIClientTests.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 23/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Nimble
import Result
import Nocilla
@testable import BothamNetworking

class BothamAPIClientTests: BothamNetworkingTestCase {

    override func tearDown() {
        BothamAPIClient.globalResponseInterceptors.removeAll()
        super.tearDown()
    }

    func testSendsGetRequestToAnyPath() {
        stubDefaultRequest("GET", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testSendsPostRequestToAnyPath() {
        stubDefaultRequest("POST", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.POST(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testSendsPutRequestToAnyPath() {
        stubDefaultRequest("PUT", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.PUT(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beBothamRequestSuccess())
    }

    func XtestSendsDeleteRequestToAnyPath() {
        stubDefaultRequest("DELETE", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.DELETE(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testSendsPatchRequestToAnyPath() {
        stubDefaultRequest("PATCH", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.PATCH(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testSendsARequestToTheURLPassedAsArgument() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath) { result in
            response = result
        }

        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testSendsARequestToTheURLPassedUsingParams() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath + "?k=v")
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath, params: ["k": "v"]) { result in
            response = result
        }

        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testReturns40XResponsesAsError() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath).andReturn(400)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath) { result in
            response = result
        }

        expect(response).toEventually(failWithError(.HTTPResponseError(statusCode: 400, body: NSData())))
    }

    func testReturns50XResponsesAsError() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath).andReturn(500)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath) { result in
            response = result
        }

        expect(response).toEventually(failWithError(.HTTPResponseError(statusCode: 500, body: NSData())))
    }

    func testInterceptRequestsUsingInterceptorsAddedLocally() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(requestInterceptor: spyInterceptor)

        var response: Result<HTTPResponse, BothamAPIClientError>? = nil
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedRequest.url).toEventually(equal(anyHost + anyPath))
        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testInterceptRequestsUsingInterceptorsAddedGlobally() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobal(requestInterceptor: spyInterceptor)

        var response: Result<HTTPResponse, BothamAPIClientError>? = nil
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedRequest.url).toEventually(equal(anyHost + anyPath))
        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testDoesNotInterceptRequestsOnceLocalInterceptorWasRemoved() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(requestInterceptor: spyInterceptor)

        bothamAPIClient.requestInterceptors.removeAll()
        var response: Result<HTTPResponse, BothamAPIClientError>? = nil
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(spyInterceptor.intercepted).toEventually(beFalse())
        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testDoesNotInterceptRequestsOnceGlobalInterceptorWasRemoved() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobal(requestInterceptor: spyInterceptor)

        BothamAPIClient.globalRequestInterceptors.removeAll()
        var response: Result<HTTPResponse, BothamAPIClientError>? = nil
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(spyInterceptor.intercepted).toEventually(beFalse())
        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testInterceptResponsesUsingInterceptorsAddedLocally() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(responseInterceptor: spyInterceptor)

        var response: Result<HTTPResponse, BothamAPIClientError>? = nil
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedResponse.statusCode).toEventually(equal(200))
        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testInterceptResponsesUsingInterceptorsAddedGlobally() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobal(responseInterceptor: spyInterceptor)

        var response: Result<HTTPResponse, BothamAPIClientError>? = nil
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedResponse.statusCode).toEventually(equal(200))
        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testDoesNotInterceptResponsesOnceLocalInterceptorWasRemoved() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(responseInterceptor: spyInterceptor)

        bothamAPIClient.requestInterceptors.removeAll()
        var response: Result<HTTPResponse, BothamAPIClientError>? = nil
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(spyInterceptor.intercepted).toEventually(beFalse())
        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testDoesNotInterceptResponseOnceGlobalInterceptorWasRemoved() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobal(responseInterceptor: spyInterceptor)

        BothamAPIClient.globalRequestInterceptors.removeAll()
        var response: Result<HTTPResponse, BothamAPIClientError>? = nil
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(spyInterceptor.intercepted).toEventually(beFalse())
        expect(response).toEventually(beBothamRequestSuccess())
    }

    func testParseHTTPResponsHeaders() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
            .andReturn(anyStatusCode)
            .withHeaders(["Content-Type":"application/json", "Server": "KarumiServer"])
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>? = nil
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response?.value?.headers?["Content-Type"]).toEventually(equal("application/json"))
        expect(response?.value?.headers?["Server"]).toEventually(equal("KarumiServer"))
        expect(response?.value?.headers?.count).toEventually(equal(2))
    }

    func testShouldReturnUnsupportedSchemeErrorIfTheRequestDoesNotUseHttp() {
        let bothamAPIClient = BothamAPIClient(baseEndpoint: "ftp://www.karumi.com")

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response?.error).toEventually(equal(BothamAPIClientError.UnsupportedURLScheme))
    }

    private func givenABothamAPIClientWithGlobal(
        requestInterceptor requestInterceptor: BothamRequestInterceptor? = nil,
        responseInterceptor: BothamResponseInterceptor? = nil)
        -> BothamAPIClient {
        let bothamAPIClient = givenABothamAPIClient()
        if let interceptor = requestInterceptor {
            BothamAPIClient.globalRequestInterceptors.append(interceptor)
        }
        if let interceptor = responseInterceptor {
            BothamAPIClient.globalResponseInterceptors.append(interceptor)
        }
        return bothamAPIClient
    }

}