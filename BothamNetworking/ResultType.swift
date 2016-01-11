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

public extension ResultType where Value == HTTPResponse, Error == BothamAPIClientError {

    public func mapJSON<U>(transform: JSON -> U) -> Result<U, BothamAPIClientError> {
        return flatMap { result in
            let data = self.value?.body
            return dataToJSONResult(data).map { transform($0) }
        }
    }

    private func dataToJSONResult(data: NSData?) -> Result<JSON, BothamAPIClientError> {
        do {
            let object: AnyObject = try NSJSONSerialization.JSONObjectWithData(data ?? NSData(),
                options: .AllowFragments)
            return Result.Success(JSON(object))
        } catch {
            let parsingError = error as NSError
            return Result.Failure(BothamAPIClientError.ParsingError(error: parsingError))
        }
    }

}