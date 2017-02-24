//
//  HTTPEncoder.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 29/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

class HTTPEncoder {

    /**
        Given a HTTPRequest instance performs the body encoding based on a Content-Type request header.

        This class only supports two different encodings: "application/x-www-form-urlencoded"
        and "application/json".

        If the request does not contain any "Content-Type" header the body is not encoded and the return
        value is nil.

        @param request to encode

        @return encoded body based on the request headers or nil if there is no any valid Content-Type
        configured.
    */
    static func encodeBody(_ request: HTTPRequest) -> Data? {
        let contentType = request.headers?["Content-Type"] ?? ""
        switch contentType {
            case "application/x-www-form-urlencoded":
                return query(request.body).data(
                    using: String.Encoding.utf8,
                    allowLossyConversion: false)
            case "application/json":
                if let body = request.body {
                    let options = JSONSerialization.WritingOptions()
                    return try? JSONSerialization.data(withJSONObject: body, options: options)
                } else {
                    return nil
                }
            default:
                return nil
        }
    }

    // The x-www-form-urlencoded code comes from this repository https://github.com/Alamofire/Alamofire

    private static func query(_ parameters: [String: AnyObject]?) -> String {
        guard let parameters = parameters else {
            return ""
        }
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(key, String(describing: value))
        }

        return (components.map { "\($0)=\($1)" } ).joined(separator: "&")
    }

    private static func queryComponents(_ key: String, _ value: String?) -> [(String, String)] {
        var components: [(String, String)] = []
        if let value = value {
            components.append((escape(key), escape("\(value)")))
        } else {
            components.append((escape(key), ""))
        }
        return components
    }

    private static func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        let allowedCharacterSet = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharacters(in: generalDelimitersToEncode + subDelimitersToEncode)
        var escaped = ""

        //===================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinense characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //===================================================================================================

        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex

            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex)!
                let range = startIndex..<endIndex

                let substring = string.substring(with: range)

                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet)
                    ?? substring

                index = endIndex
            }
        }

        return escaped
    }

}
