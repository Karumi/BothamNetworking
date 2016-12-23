//
//  BothamNetworkingTestCase.swift
//  BothamNetworking
//
//  Created by Davide Mendolia on 31/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import XCTest
import Nocilla
import BothamNetworking

class BothamNetworkingTestCase: NocillaTestCase {
    let anyHost = "http://www.anyhost.com/"
    let anyPath = "path"
    let anyHTTPMethod = HTTPMethod.GET
    let anyStatusCode = 200

    @discardableResult func stubRequest(_ method: String, _ url: String) -> LSStubRequestDSL {
        return Nocilla.stubRequest(method, (url as NSString) as LSMatcheable)
    }

    func givenABothamAPIClient() -> BothamAPIClient {
        return BothamAPIClient(baseEndpoint: anyHost)
    }

    func givenABothamAPIClientWithLocal(
        requestInterceptor: BothamRequestInterceptor? = nil,
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

    func givenABothamAPIClientWithLocal(
        requestInterceptor requestInterceptors: [BothamRequestInterceptor] = [BothamRequestInterceptor](),
        responseInterceptors: [BothamResponseInterceptor] = [BothamResponseInterceptor]()) -> BothamAPIClient {
            let bothamAPIClient = givenABothamAPIClient()
            bothamAPIClient.requestInterceptors.append(contentsOf: requestInterceptors)
            bothamAPIClient.responseInterceptors.append(contentsOf: responseInterceptors)
            return bothamAPIClient
    }

    func givenABothamAPIClientWithGlobal(
        requestInterceptor: BothamRequestInterceptor? = nil,
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
