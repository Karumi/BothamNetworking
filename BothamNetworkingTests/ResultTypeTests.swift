//
//  ResultTypeTests.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 07/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation
import XCTest
import Nimble
import BothamNetworking
@testable import BothamNetworking

class ResultTypeTests: XCTestCase {

    struct Empty: Decodable {
    }

    func testReturnsMalformedJsonAsAParsingError() {
        let malformedJSON = "{".data(using: String.Encoding.utf8)
        let response = HTTPResponse(statusCode: 200, headers: nil, body: malformedJSON!)
        let result = Result<HTTPResponse, BothamAPIClientError>.success(response)

        let jsonMappingError: Result<Empty, BothamAPIClientError> = result.mapJSON()

        expect { try jsonMappingError.get() }
            .to(throwError(BothamAPIClientError.parsingError(error: NSError.anyError())))
    }

    struct Box: Decodable {
        let a: String
    }

    func testReturnsResponseBodyAsJSON() {
        let malformedJSON = "{\"a\":\"b\"}".data(using: String.Encoding.utf8)
        let response = HTTPResponse(statusCode: 200, headers: nil, body: malformedJSON!)
        let result = Result<HTTPResponse, BothamAPIClientError>.success(response)

        let parsedValue: Result<Box, BothamAPIClientError> = result.mapJSON()

        expect { try parsedValue.get().a }.to(equal("b"))
    }

}

extension NSError {

    static func anyError() -> NSError {
        return NSError(domain: "Any error", code: 0, userInfo: nil)
    }

}
