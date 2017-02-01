//
//  ResultType.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 07/01/16.
//  Copyright © 2016 GoKarumi S.L. All rights reserved.
//

import Foundation
import Result
import SwiftyJSON

public extension ResultProtocol where Value == HTTPResponse, Error == BothamAPIClientError {

    public func mapJSON<U>(_ transform: @escaping (JSON) -> U) -> Result<U, BothamAPIClientError> {
        return flatMap { result in
            let data = self.value?.body
            return dataToJSONResult(data as NSData?).map { transform($0) }
        }
    }

    private func dataToJSONResult(_ data: NSData?) -> Result<JSON, BothamAPIClientError> {
        do {
            let object: Any = try JSONSerialization.jsonObject(with: (data ?? NSData()) as Data,
                options: .allowFragments)
            return Result.success(JSON(object))
        } catch {
            let parsingError = error as NSError
            return Result.failure(BothamAPIClientError.parsingError(error: parsingError))
        }
    }

}
