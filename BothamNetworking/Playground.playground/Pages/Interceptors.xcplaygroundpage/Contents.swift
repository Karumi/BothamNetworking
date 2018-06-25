//: [Previous](@previous)

import Foundation
import XCPlayground
import BothamNetworking

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let client = BothamAPIClient(baseEndpoint: "https://api.github.com/repos/Karumi/BothamNetworking")
client.requestInterceptors.append(NSLogInterceptor())
client.responseInterceptors.append(NSLogInterceptor())

client.GET("/issues") { _ in }

//: [Next](@next)
