//
//  NocillaTestCase.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import XCTest
import OHHTTPStubs

class NocillaTestCase: XCTestCase {

    private var currentStub: OHHTTPStubsDescriptor?

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    private func isMethod(_ method: String) -> OHHTTPStubsTestBlock {
        switch method {
        case "GET":
            return isMethodGET()
        case "POST":
            return isMethodPOST()
        case "PUT":
            return isMethodPUT()
        case "HEAD":
            return isMethodHEAD()
        case "PATCH":
            return isMethodPATCH()
        case "DELETE":
            return isMethodDELETE()
        default:
            return isMethodGET()
        }
    }

    @discardableResult func stubRequest(_ method: String, _ url: String, withHeader: (String, String)? = nil, andReturn: Int = 200) -> Self {
        var condition = isMethod(method) && isAbsoluteURLString(url)
        if let withHeader = withHeader {
            condition = condition && hasHeaderNamed(withHeader.0, value: withHeader.1)
        }
        self.currentStub = stub(condition: condition) { _ in
            let stubData = "".data(using: String.Encoding.utf8)
            return OHHTTPStubsResponse(data: stubData!, statusCode:Int32(andReturn), headers:nil)
        }
        return self
    }

    func fromJsonFile(_ fileName: String) -> String {
        let classBundle = Bundle(for: self.classForCoder)
        let path = classBundle.path(forResource: fileName, ofType: "json")
        let absolutePath =  path ?? ""
        do {
            return try String(contentsOfFile: absolutePath, encoding: String.Encoding.utf8)
        } catch _ {
            print("Error trying to read file \(absolutePath). The file does not exist")
            return ""
        }
    }

}
