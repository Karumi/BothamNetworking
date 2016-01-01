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

class AuthenticationTests: BothamNetworkingTestCase {
    private class SpyBasicAuthentication: BasicAuthentication {
        var authenticationError: Bool = false

        private func credentials() -> (username: String, password: String) {
            return ("Aladdin", "open sesame")
        }

        private func onAuthenticationError(realm: String) {
            authenticationError = true
        }
    }

    func testSendsGetRequestWithBasicAuthentication() {
        stubRequest("GET", anyHost + anyPath)
            .withHeader("Authorization", "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
            .andReturn(200)
            .withHeaders(["Content-Type":"application/json"])
        let bothamAPIClient = givenABothamAPIClientWithLocal(requestInterceptor: SpyBasicAuthentication())

        let result = bothamAPIClient.GET(anyPath)

        expect(result).toEventually(beBothamRequestSuccess())
    }

    func testSendsGetRequestWithAuthenticationError() {
        stubRequest("GET", anyHost + anyPath)
            .withHeader("Authorization", "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
            .andReturn(401)
            .withHeaders([
                "Content-Type":"application/json",
                "WWW-Authenticate":"Basic realm=\"WallyWorld\"",
                ])

        let basicAuthentication = SpyBasicAuthentication()
        let bothamAPIClient = givenABothamAPIClientWithLocal(requestInterceptor: basicAuthentication, responseInterceptor: basicAuthentication)

        let result = bothamAPIClient.GET(anyPath)

        expect(result).toEventually(failWithError(BothamAPIClientError.HTTPResponseError(statusCode: 401, body: NSData())))
        expect(basicAuthentication.authenticationError).toEventually(beTrue())
    }
}