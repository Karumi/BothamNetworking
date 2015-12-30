//
//  BothamRequestInterceptor.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 28/12/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation

public protocol BothamRequestInterceptor {

    func intercept(request: HTTPRequest) -> HTTPRequest

}