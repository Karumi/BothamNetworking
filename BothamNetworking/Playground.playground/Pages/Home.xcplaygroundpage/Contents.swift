//: Welcome to the BothamNetworking's Playground!

import Foundation
import XCPlayground
import BothamNetworking

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let client = BothamAPIClient(baseEndpoint: "http://api.randomuser.me")

client.GET("/") { result in
    result.mapJSON { json in
        print(json)
    }
}

//: * [Send and read headers](Headers)
//: * [Send parameters](Parameters)
//: * [Send body](body)
//: * [Interceptors](Interceptors)
//: * [BasicAuthentication using interceptors](BasicAuthentication)
