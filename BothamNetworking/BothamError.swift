//
//  BothamError.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 23/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

public enum BothamError {

    case HTTPResponseError(statusCode: Int, body: String)
    case NetworkError
    case BothamError(error: NSError)

}
