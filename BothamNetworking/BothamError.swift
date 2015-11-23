//
//  BothamError.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 23/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

public enum BothamError: ErrorType, Equatable {

    case HTTPResponseError(statusCode: Int, body: String)
    case NetworkError
    case UnkownError(error: NSError)

}

public func ==(lhs: BothamError, rhs: BothamError) -> Bool {
    switch (lhs, rhs) {
        case (let .HTTPResponseError(statusCode1,body1), let .HTTPResponseError(statusCode2,body2)):
            return statusCode1 == statusCode2 && body1 == body2
        case (let .UnkownError(error1), let .UnkownError(error2)):
            return error1 == error2
        case (.NetworkError, .NetworkError):
            return true
        default:
            return false
    }
}
