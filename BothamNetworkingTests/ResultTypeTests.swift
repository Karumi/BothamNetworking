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
import Result
import SwiftyJSON
import BothamNetworking
@testable import BothamNetworking

class ResultTypeTests: XCTestCase {

    func testReturnsMalformedJsonAsAParsingError() {
        let malformedJSON = "{".dataUsingEncoding(NSUTF8StringEncoding)
        let response = HTTPResponse(statusCode: 200, headers: nil, body: malformedJSON!)
        let result = Result<HTTPResponse, BothamAPIClientError>.Success(response)

        let jsonMappingError = result.mapJSON { return $0 }

        expect(jsonMappingError.error).to(equal(BothamAPIClientError.ParsingError(error: NSError.anyError())))
    }

    func testReturnsResponseBodyAsJSON() {
        let malformedJSON = "{\"a\":\"b\"}".dataUsingEncoding(NSUTF8StringEncoding)
        let response = HTTPResponse(statusCode: 200, headers: nil, body: malformedJSON!)
        let result = Result<HTTPResponse, BothamAPIClientError>.Success(response)

        let parsedValue = result.mapJSON { json in
            json["a"]
        }

        expect(parsedValue.value).to(equal("b"))
    }

}

extension NSError {

    static func anyError() -> NSError {
        return NSError(domain: "Any error", code: 0, userInfo: nil)
    }

}