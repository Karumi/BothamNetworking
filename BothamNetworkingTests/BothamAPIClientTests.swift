//
//  BothamAPIClientTests.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 23/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Nimble
import Nocilla
@testable import BothamNetworking

class BothamAPIClientTests: BothamNetworkingTestCase {

    override func tearDown() {
        BothamAPIClient.globalResponseInterceptors.removeAll()
        super.tearDown()
    }

    func testSendsGetRequestToAnyPath() {
        stubRequest("GET", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsPostRequestToAnyPath() {
        stubRequest("POST", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.POST(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsPutRequestToAnyPath() {
        stubRequest("PUT", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.PUT(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsDeleteRequestToAnyPath() {
        stubRequest("DELETE", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.DELETE(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsPatchRequestToAnyPath() {
        stubRequest("PATCH", anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.PATCH(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsARequestToTheURLPassedAsArgument() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsARequestToTheURLPassedUsingParams() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath + "?k=v")
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath, params: ["k": "v"]) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testReturns40XResponsesAsError() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath).andReturn(400)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath) { result in
            response = result
        }

        expect(response).toEventually(failWithError(.httpResponseError(statusCode: 400, body: Data())))
    }

    func testReturns50XResponsesAsError() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath).andReturn(500)
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.sendRequest(anyHTTPMethod, path: anyPath) { result in
            response = result
        }

        expect(response).toEventually(failWithError(.httpResponseError(statusCode: 500, body: Data())))
    }

    func testInterceptRequestsUsingInterceptorsAddedLocally() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(requestInterceptor: spyInterceptor)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedRequest.url).toEventually(equal(anyHost + anyPath))
    }

    func testInterceptRequestsUsingInterceptorsAddedGlobally() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobal(requestInterceptor: spyInterceptor)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedRequest.url).toEventually(equal(anyHost + anyPath))
    }

    func testDoesNotInterceptRequestsOnceLocalInterceptorWasRemoved() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(requestInterceptor: spyInterceptor)

        bothamAPIClient.requestInterceptors.removeAll()
        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
        expect(spyInterceptor.intercepted).toEventually(beFalse())
    }

    func testDoesNotInterceptRequestsOnceGlobalInterceptorWasRemoved() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyRequestInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobal(requestInterceptor: spyInterceptor)

        BothamAPIClient.globalRequestInterceptors.removeAll()
        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
        expect(spyInterceptor.intercepted).toEventually(beFalse())
    }

    func testInterceptResponsesUsingInterceptorsAddedLocally() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(responseInterceptor: spyInterceptor)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedResponse.statusCode).toEventually(equal(200))
    }

    func testInterceptResponsesUsingInterceptorsAddedGlobally() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobal(responseInterceptor: spyInterceptor)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
        expect(spyInterceptor.intercepted).toEventually(beTrue())
        expect(spyInterceptor.interceptedResponse.statusCode).toEventually(equal(200))
    }

    func testDoesNotInterceptResponsesOnceLocalInterceptorWasRemoved() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(responseInterceptor: spyInterceptor)

        bothamAPIClient.responseInterceptors.removeAll()
        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
        expect(spyInterceptor.intercepted).toEventually(beFalse())
    }

    func testDoesNotInterceptResponseOnceGlobalInterceptorWasRemoved() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let spyInterceptor = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithGlobal(responseInterceptor: spyInterceptor)

        BothamAPIClient.globalResponseInterceptors.removeAll()
        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
        expect(spyInterceptor.intercepted).toEventually(beFalse())
    }

    func testParseHTTPResponsHeaders() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
            .andReturn(anyStatusCode)?
            .withHeaders(["Content-Type": "application/json", "Server": "KarumiServer"])
        let bothamAPIClient = givenABothamAPIClient()

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect { try? response?.get().headers?["Content-Type"] }.toEventually(equal("application/json"))
        expect { try? response?.get().headers?["Server"] }.toEventually(equal("KarumiServer"))
        expect { try? response?.get().headers?.count }.toEventually(equal(2))
    }

    func testShouldReturnUnsupportedSchemeErrorIfTheRequestDoesNotUseHttp() {
        let bothamAPIClient = BothamAPIClient(baseEndpoint: "ftp://www.karumi.com")

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect { try response?.get() }.to(throwError(BothamAPIClientError.unsupportedURLScheme))
    }

    func testEncodesEmptyParameterValuesProperly() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath + "?a=")
        let bothamAPIClient = BothamAPIClient(baseEndpoint: anyHost)

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath, parameters: ["a": ""]) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testDoesNotInvokeAllTheResponseInterceptorsIfAPreviousInterceptorReturnsAnError() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let interceptor1 = SpyResponseInterceptor()
        interceptor1.error = .networkError
        let interceptor2 = SpyResponseInterceptor()
        let bothamAPIClient = givenABothamAPIClientWithLocal(responseInterceptors: [interceptor1, interceptor2])

        var response: Result<HTTPResponse, BothamAPIClientError>?
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(failWithError(.networkError))
        expect(interceptor1.intercepted).toEventually(beTrue())
        expect(interceptor2.intercepted).toEventually(beFalse())
    }

}
