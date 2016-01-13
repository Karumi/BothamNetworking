//: [Previous](@previous)

import Foundation
import XCPlayground
import BothamNetworking

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

struct HTTPBinAuthentication: BasicAuthentication {
    let credentials = (username: "user", password: "passwd")

    func onAuthenticationError(realm: String) {
        print(realm)
    }
}

let authentication = HTTPBinAuthentication()
let client = BothamAPIClient(baseEndpoint: "https://httpbin.org")
client.requestInterceptors.append(authentication)
client.responseInterceptors.append(authentication)

client.GET("/basic-auth/user/passwd") { result in
    switch result {
    case let .Success(response) :
        print("Server: " + String(data: response.body, encoding: NSUTF8StringEncoding)!)
    case let .Failure(error):
        print(error)
    }
}
//: [Next](@next)
