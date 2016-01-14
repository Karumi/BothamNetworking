//
//  BothamRetryRequestTests.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 14/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation
import Nimble
import Result
import Nocilla
import BothamNetworking

class BothamRetryRequestTests: BothamNetworkingTestCase {

    func testRetriesRequestIfResponseInterceptorsReturnsARetryError() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let interceptor = RetryResponseInterceptor(numberOfRetries: 1)
        let apiClient = givenABothamAPIClientWithLocal(responseInterceptor: interceptor)

        var response: Result<HTTPResponse, BothamAPIClientError>!
        apiClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
        expect(interceptor.interceptCalls).to(equal(2))
    }

    func testRetriesRequestsMoreThanOnce() {
        stubRequest(anyHTTPMethod.rawValue, anyHost + anyPath)
        let interceptor = RetryResponseInterceptor(numberOfRetries: 2)
        let apiClient = givenABothamAPIClientWithLocal(responseInterceptor: interceptor)

        var response: Result<HTTPResponse, BothamAPIClientError>!
        apiClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
        expect(interceptor.interceptCalls).to(equal(3))
    }

}