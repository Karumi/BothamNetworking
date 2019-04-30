//
//  ResultType.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 07/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation
import Result

public extension Result where Value == HTTPResponse, Error == BothamAPIClientError {

    var iso8601JSONDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }

    func mapJSON<T: Decodable>() -> Result<T, BothamAPIClientError> {
        return flatMap {
            return dataToJSONResult($0.body)
        }
    }

    private func dataToJSONResult<T: Decodable>(_ data: Data) -> Result<T, BothamAPIClientError> {
        do {
            let object = try self.iso8601JSONDecoder.decode(T.self, from: data)
            return .success(object)
        } catch {
            let parsingError = error as NSError
            return .failure(BothamAPIClientError.parsingError(error: parsingError))
        }
    }

}
