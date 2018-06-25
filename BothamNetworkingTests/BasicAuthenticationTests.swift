//
//  BaseAuthenticationTests.swift
//  BothamNetworking
//
//  Created by Davide Mendolia on 31/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Nimble
import Result
import Nocilla
import BothamNetworking

class BasicAuthenticationTests: BothamNetworkingTestCase {

    func testSendsAnyHttpMethodRequestWithBasicAuthentication() {
        stubRequest("GET", anyHost + anyPath)
            .withHeader("Authorization", "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==")
        let bothamAPIClient = givenABothamAPIClientWithLocal(requestInterceptor: SpyBasicAuthentication())

        var response: Result<HTTPResponse, BothamAPIClientError>!
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(beSuccess())
    }

    func testSendsAnyHttpMethodRequestWithAuthenticationError() {
        stubRequest("GET", anyHost + anyPath)
            .withHeader("Authorization", "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==")?
            .andReturn(401)?
            .withHeader("WWW-Authenticate", "Basic realm=\"WallyWorld\"")

        let basicAuthentication = SpyBasicAuthentication()
        let bothamAPIClient = givenABothamAPIClientWithLocal(requestInterceptor: basicAuthentication,
            responseInterceptor: basicAuthentication)

        var response: Result<HTTPResponse, BothamAPIClientError>!
        bothamAPIClient.GET(anyPath) { result in
            response = result
        }

        expect(response).toEventually(failWithError(BothamAPIClientError.httpResponseError(statusCode: 401,
            body: Data())))
        expect(basicAuthentication.authenticationError).toEventually(beTrue())
    }
}

private class SpyBasicAuthentication: BasicAuthentication {
    var authenticationError: Bool = false

    var credentials: (username: String, password: String) {
        return ("Aladdin", "open sesame")
    }

    fileprivate func onAuthenticationError(_ realm: String) {
        authenticationError = true
    }
}
