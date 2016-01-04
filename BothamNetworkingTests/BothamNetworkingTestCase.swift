//
//  BothamNetworkingTestCase.swift
//  BothamNetworking
//
//  Created by Davide Mendolia on 31/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import XCTest
import BothamNetworking

class BothamNetworkingTestCase: NocillaTestCase {
    let anyHost = "http://www.anyhost.com/"
    let anyPath = "path"
    let anyHTTPMethod = HTTPMethod.GET
    let anyStatusCode = 200

    func givenABothamAPIClient() -> BothamAPIClient {
        return BothamAPIClient(baseEndpoint: anyHost)
    }

    func givenABothamAPIClientWithLocal(
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
}