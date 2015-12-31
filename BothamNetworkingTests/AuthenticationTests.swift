//
//  AuthenticationTests.swift
//  BothamNetworking
//
//  Created by Davide Mendolia on 31/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Nimble
import BrightFutures
import Nocilla
import BothamNetworking

class AuthenticationTests: NocillaTestCase {
    private let anyHost = "http://www.anyhost.com/"
    private let anyPath = "path"
    private let anyHTTPMethod = HTTPMethod.GET
    private let anyStatusCode = 200

    func testSendsGetRequestWithBasicAuthentication() {
        stubRequest("GET", anyHost + anyPath)
            .withHeader("Authorization", "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
            .andReturn(200)
            .withHeaders(["Content-Type":"application/json"])
        let bothamAPIClient = givenABothamAPIClientWithBasicAuthentication()

        let result = bothamAPIClient.GET(anyPath)

        expect(result).toEventually(beBothamRequestSuccess())
    }

    private func givenABothamAPIClientWithBasicAuthentication() -> BothamAPIClient {
        class FakeCredentialsProvider: CredentialsProvider {
            var credentials: (username: String, password: String) {
                return ("Aladdin", "open sesame")
            }
        }
        class SpyBasicAuthentication: BasicAuthentication {
            var credentialsProvider:CredentialsProvider = FakeCredentialsProvider()
        }

        return givenABothamAPIClientWithLocal(requestInterceptor: SpyBasicAuthentication())
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

    private func givenABothamAPIClient() -> BothamAPIClient {
        return BothamAPIClient(baseEndpoint: anyHost)
    }
}