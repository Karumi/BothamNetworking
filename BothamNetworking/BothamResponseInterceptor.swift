//
//  BothamResponseInterceptor.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 29/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

public protocol BothamResponseInterceptor {

    func intercept(response: HTTPResponse) -> HTTPResponse
    
}