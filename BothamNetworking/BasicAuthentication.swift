//
//  BasicAuthentication.swift
//  BothamNetworking
//
//  Created by Davide Mendolia on 31/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

/**
 * Basic Authentication http://tools.ietf.org/html/rfc2617
 */
public protocol BasicAuthentication: BothamRequestInterceptor, BothamResponseInterceptor {
    var credentials: (username: String, password: String) { get }
    func onAuthenticationError(realm: String) -> Void
}

extension BasicAuthentication {
    public func intercept(request: HTTPRequest) -> HTTPRequest {

        let userPass = "\(credentials.username):\(credentials.password)"

        let userPassData = userPass.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64UserPass = userPassData.base64EncodedStringWithOptions([])

        let header = ["Authorization" : "Basic \(base64UserPass)"]

        return request.appendHeaders(header)
    }

    public func intercept(response: HTTPResponse) -> HTTPResponse {
        if response.statusCode == 401, let unauthorizedHeader = response.headers?["WWW-Authenticate"] {
            let regex = try! NSRegularExpression(pattern: "Basic realm=\"(.*)\"", options: [])
            let range = NSMakeRange(0, unauthorizedHeader.utf8.count)
            if let match = regex.firstMatchInString(unauthorizedHeader, options: [], range: range) {
                let realm = (unauthorizedHeader as NSString).substringWithRange(match.rangeAtIndex(1))
                onAuthenticationError(realm)
            }
        }
        return response
    }
}