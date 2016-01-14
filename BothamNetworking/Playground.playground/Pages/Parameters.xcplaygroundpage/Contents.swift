//: [Previous](@previous)

import Foundation
import XCPlayground
import BothamNetworking

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let client = BothamAPIClient(baseEndpoint: "http://api.randomuser.me")

client.GET("/", parameters: ["gender": "male"]) { result in
        result.mapJSON { json in
            print(json)
    }
}

//: [Next](@next)
