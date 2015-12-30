//
//  BothamAPIClientTests.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 23/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Nimble
import BrightFutures
import Nocilla
@testable import BothamNetworking

class BothamAPIClientTests: NocillaTestCase {

    private let anyHost = "http://www.anyhost.com/"
    private let anyPath = "path"
    private let anyHTTPMethod = HTTPMethod.GET
    private let anyStatusCode = 200

    override func tearDown() {
        BothamAPIClient.globalResponseInterceptors.removeAll()
        super.tearDown()
    }

    func testSendsGetRequestToAnyPath() {
        stubDefaultRequest("GET", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.GET(anyPath)

        expect(result).toEventually(beBothamRequestSuccess())
    }

    func testSendsPostRequestToAnyPath() {
        stubDefaultRequest("POST", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.POST(anyPath)

        expect(result).toEventually(beBothamRequestSuccess())
    }

    func testSendsPutRequestToAnyPath() {
        stubDefaultRequest("PUT", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.PUT(anyPath)

        expect(result).toEventually(beBothamRequestSuccess())
    }

    func XtestSendsDeleteRequestToAnyPath() {
        stubDefaultRequest("DELETE", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.DELETE(anyPath)

        expect(result).toEventually(beBothamRequestSuccess())
    }

    func testSendsPatchRequestToAnyPath() {
        stubDefaultRequest("PATCH", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.PATCH(anyPath)

        expect(result).toEventually(beBothamRequestSuccess())
    }

    func testSendsARequestToTheURLPassedAsArgument() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath)

        expect(result).toEventually(beBothamRequestSuccess())
    }

    func testSendsARequestToTheURLPassedUsingParams() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath + "?k=v")
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath, params: ["k": "v"])

        expect(result).toEventually(beBothamRequestSuccess())
    }

    func testReturns40XResponsesAsError() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath).andReturn(400)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath)

        expect(result).toEventually(failWithError(.HTTPResponseError(statusCode: 400, body: NSData())))
    }

    func testReturns50XResponsesAsError() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath).andReturn(500)
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath)

        expect(result).toEventually(failWithError(.HTTPResponseError(statusCode: 500, body: NSData())))
    }

    func testInterceptRequestsUsingInterceptorsAddedLocally() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(requestInterceptor: spyInterceptor)

        let result = bothamAPIClient.GET(anyPath)

        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedRequest.url).toEventually(equal(anyHost + anyPath))
        waitForRequestFinished(result)
    }

    func testInterceptRequestsUsingInterceptorsAddedGlobally() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobal(requestInterceptor: spyInterceptor)

        let result = bothamAPIClient.GET(anyPath)

        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedRequest.url).toEventually(equal(anyHost + anyPath))
        waitForRequestFinished(result)
    }

    func testDoesNotInterceptRequestsOnceLocalInterceptorWasRemoved() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(requestInterceptor: spyInterceptor)

        bothamAPIClient.requestInterceptors.removeAll()
        let result = bothamAPIClient.GET(anyPath)

        expect(spyInterceptor.intercepted).toEventually(beFalse())
        waitForRequestFinished(result)
    }

    func testDoesNotInterceptRequestsOnceGlobalInterceptorWasRemoved() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobal(requestInterceptor: spyInterceptor)

        BothamAPIClient.globalRequestInterceptors.removeAll()
        let result = bothamAPIClient.GET(anyPath)

        expect(spyInterceptor.intercepted).toEventually(beFalse())
        waitForRequestFinished(result)
    }

    func testInterceptResponsesUsingInterceptorsAddedLocally() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(responseInterceptor: spyInterceptor)

        let result = bothamAPIClient.GET(anyPath)

        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedResponse.statusCode).toEventually(equal(200))
        waitForRequestFinished(result)
    }

    func testInterceptResponsesUsingInterceptorsAddedGlobally() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobal(responseInterceptor: spyInterceptor)

        let result = bothamAPIClient.GET(anyPath)

        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedResponse.statusCode).toEventually(equal(200))
        waitForRequestFinished(result)
    }

    func testDoesNotInterceptResponsesOnceLocalInterceptorWasRemoved() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(responseInterceptor: spyInterceptor)

        bothamAPIClient.requestInterceptors.removeAll()
        let result = bothamAPIClient.GET(anyPath)

        expect(spyInterceptor.intercepted).toEventually(beFalse())
        waitForRequestFinished(result)
    }

    func testDoesNotInterceptResponseOnceGlobalInterceptorWasRemoved() {
        stubDefaultRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobal(responseInterceptor: spyInterceptor)

        BothamAPIClient.globalRequestInterceptors.removeAll()
        let result = bothamAPIClient.GET(anyPath)

        expect(spyInterceptor.intercepted).toEventually(beFalse())
        waitForRequestFinished(result)
    }

    func testParseHTTPResponsHeaders() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
            .andReturn(anyStatusCode)
            .withHeaders(["Content-Type":"application/json", "Server": "KarumiServer"])
        let bothamAPIClient = givenABothamAPIClient()

        let result = bothamAPIClient.GET(anyPath)

        expect(result.value?.headers?["Content-Type"]).toEventually(equal("application/json"))
        expect(result.value?.headers?["Server"]).toEventually(equal("KarumiServer"))
        expect(result.value?.headers?.count).toEventually(equal(2))
    }

    private func givenABothamAPIClientWithLocal(
        requestInterceptor requestInterceptor: BothamRequestInterceptor? = nil,
        responseInterceptor: BothamResponseInterceptor? = nil) -> BothamAPIClient {
        let bothamAPIClient = givenABothamAPIClient()
        if let interceptor = requestInterceptor {
            bothamAPIClient.requestInterceptors.append(interceptor)
        }
        if let interceptor = responseInterceptor {
            bothamAPIClient.responseInterceptors.append(interceptor)
        }
        return bothamAPIClient
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

    private func givenABothamAPIClient() -> BothamAPIClient {
        return BothamAPIClient(baseEndpoint: anyHost, httpClient: NSHTTPClient())
    }

    private func waitForRequestFinished(result: Future<HTTPResponse, BothamAPIClientError>) {
        expect(result).toEventually(beBothamRequestSuccess())
    }
}