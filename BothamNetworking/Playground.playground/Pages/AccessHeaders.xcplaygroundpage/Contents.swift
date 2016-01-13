//: [Previous](@previous)

import Foundation
import XCPlayground
import BothamNetworking

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let client = BothamAPIClient(baseEndpoint: "https://api.github.com/repos/Karumi/BothamNetworking")

client.GET("/issues", headers: [
    "User-Agent": "BothamNetworking Headers",
    "Accept": "application/json; q=0.5",
    ]) { result in
        switch result {
        case let .Success(response) :
            print("Server: " + response.headers!["Server"]!)
            print("Date: " + response.headers!["Date"]!)
            print("Vary: " + response.headers!["Vary"]!)
        case let .Failure(error):
            print(error)
        }
}
//: [Next](@next)
