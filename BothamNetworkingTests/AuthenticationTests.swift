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
        class DummyBasicAuthentication: BasicAuthentication {
            let credentialsProvider:CredentialsProvider = FakeCredentialsProvider()
            let onAuthenticationError: () -> () = { }
        }

        return givenABothamAPIClientWithLocal(requestInterceptor: DummyBasicAuthentication())
    }
}