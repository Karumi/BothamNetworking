//
//  BasicAuthentication.swift
//  BothamNetworking
//
//  Created by Davide Mendolia on 31/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import Result

/**
 * Basic Authentication http://tools.ietf.org/html/rfc2617
 */
public protocol BasicAuthentication: BothamRequestInterceptor, BothamResponseInterceptor {
    var credentials: (username: String, password: String) { get }
    func onAuthenticationError(_ realm: String) -> Void
}

extension BasicAuthentication {
    public func intercept(_ request: HTTPRequest) -> HTTPRequest {

        let userPass = "\(credentials.username):\(credentials.password)"

        let userPassData = userPass.data(using: String.Encoding.utf8)!
        let base64UserPass = userPassData.base64EncodedString(options: [])

        let header = ["Authorization" : "Basic \(base64UserPass)"]

        return request.appendingHeaders(header)
    }

    public func intercept(_ response: HTTPResponse,
        completion: (Result<HTTPResponse, BothamAPIClientError>) -> Void) {
        if response.statusCode == 401, let unauthorizedHeader = response.headers?["WWW-Authenticate"] {
            let regex = try! NSRegularExpression(pattern: "Basic realm=\"(.*)\"", options: []) // swiftlint:disable:this force_try
            let range = NSMakeRange(0, unauthorizedHeader.utf8.count)
            if let match = regex.firstMatch(in: unauthorizedHeader, options: [], range: range) {
                let realm = (unauthorizedHeader as NSString).substring(with: match.rangeAt(1))
                onAuthenticationError(realm)
            }
        }
        completion(Result.success(response))
    }
}
