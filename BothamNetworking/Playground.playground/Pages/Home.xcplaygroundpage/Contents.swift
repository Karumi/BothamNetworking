
import Foundation
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

//: Prepare your BothamAPIClient instance.

import BothamNetworking

let botham = BothamAPIClient(baseEndpoint: "http://api.randomuser.me")
botham.requestInterceptors.append(JSONHeadersRequestInterceptor())

//: Send HTTP requests:

botham.GET("/") { result in
    result.mapJSON { json in
        print(json)
    }
}

//: * [Send and read headers](Headers)
//: * [Send parameters](Parameters)
//: * [BasicAuthentication against httpbin](BasicAuthentication)
