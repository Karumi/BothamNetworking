//: [Previous](@previous)

import Foundation
import XCPlayground
import BothamNetworking

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let client = BothamAPIClient(baseEndpoint: "https://httpbin.org")

client.POST("/post",body: ["scopes": ["read:org", "user:email"], "id": 3]) { result in
    result.mapJSON { json in
        print(json)
    }
}

//: [Next](@next)
