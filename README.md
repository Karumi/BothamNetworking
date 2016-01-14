# ![Karumi logo][karumilogo] BothamNetworking [![Build Status](https://travis-ci.org/Karumi/BothamNetworking.svg?branch=master)](https://travis-ci.org/Karumi/BothamNetworking)

BothamNetworking is a networking framework written in Swift.

This project will help you to setup all your API clients and implement your networking layer easily. BothamNetworking provides classes to send HTTP requests and obtain HTTP responses ready to parse with just a few lines.

In addition, BothamNetworking adds a Request/Response interceptor mechanisms to be able to modify the HTTPRequest before being sent and the HTTPResponse after being received. This mechanism can be used to implement authentication policies, add headers to a request or add log traces. BothamNetworking contains some already implemented interceptors like ``NSLogInterceptor``, ``JSONHeadersRequestInterceptor`` and some authentication mechanisms like ``BaseAuthentication``.

##Usage

This framework contains all the classes needed to implement your networking layer with an easy to use facade named ``BothamAPIClient``. If you love Swift Playgrounds clone this project and review the playgrounds we've created to show how to use this framework.

###Send a request using different HTTP methods:

```swift
let apiClient = BothamAPIClient(baseEndpoint: "https://api.github.com/repos/Karumi/BothamNetworking")

apiClient.GET("/issues") { result in
       ...
}

apiClient.POST("/issues") { result in
       ...
}

apiClient.PUT("/issues") { result in
       ...
}

apiClient.DELETE("/issues/1") { result in
       ...
}

```

###Add headers to the request:

```swift
apiClient.GET("/issues", headers: ["User-Agent": "BothamNetworking Headers", "Accept": "application/json; q=0.5"]) { result in
       ...
}
```

###Add parameters to the request:

```swift
apiClient.DELETE("/issues", parameters: ["id": "1"]) { result in
       ...
}
```

###Add a body to the request:

```swift
apiClient.POST("/authorizations", body: ["scopes": ["repo_status", "user:email"]]) { result in
       ...
}
```
**The body encoding will be determined by the HTTP headers used. To encode your body using json add a "ContentType: application/json" header to your request**


###Request execution result:

BothamNetworking uses ``Result`` return type composed by ``HTTPResponse`` or ``BothamAPIClientError`` instances. We have added a ``ResultType`` extension to be able to provide an easy to use mechanism to parse your response information using ``SwiftyJSON`` as parsing library.

```swift
apiClient.GET("/repos") { result in
	result.mapJSON { json in
       for result in json["results"].arrayValue {
			let id = result["id"].stringValue
			let name = result["name"].stringValue
		}
    }
}
```

This is the information available in the ``HTTPResponse`` struct:

```swift
public struct HTTPResponse {

    public let statusCode: Int
    public let headers: CaseInsensitiveDictionary<String>?
    public let body: NSData
    
    ...
    
}
```

The errors BothamNetworking can return are:

```swift
public enum BothamAPIClientError: ErrorType, Equatable {

    case HTTPResponseError(statusCode: Int, body: NSData)
    case NetworkError
    case HTTPClientError(error: NSError)
    case ParsingError(error: NSError)
    case UnsupportedURLScheme
    case Retry

}
```

###Interceptors:

``BothamRequestInterceptor`` and ``BothamResponseInterceptor`` are two protocols you can use to modify a ``HTTPRequest`` instance before sending it or a ``HTTPResponse`` before receiving it. This mechansim can be used to implement authentication policies, add default information to a request, add log traces or retry requests. An example could be ``NSLogInterceptor``, ``JSONHeadersRequestInterceptor`` or ``BasicAuthentication``.

```swift
class JSONHeadersRequestInterceptor: BothamRequestInterceptor {

	func intercept(request: HTTPRequest) -> HTTPRequest {
        return request.appendingHeaders(["Content-Type": "application/json", "Accept": "application:json"])
    }
}

```

```swift
public protocol BasicAuthentication: BothamRequestInterceptor, BothamResponseInterceptor {
    var credentials: (username: String, password: String) { get }
    func onAuthenticationError(realm: String) -> Void
}

extension BasicAuthentication {
    public func intercept(request: HTTPRequest) -> HTTPRequest {

        let userPass = "\(credentials.username):\(credentials.password)"

        let userPassData = userPass.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64UserPass = userPassData.base64EncodedStringWithOptions([])

        let header = ["Authorization" : "Basic \(base64UserPass)"]

        return request.appendingHeaders(header)
    }

    public func intercept(response: HTTPResponse,
        completion: (Result<HTTPResponse, BothamAPIClientError>) -> Void) {
        if response.statusCode == 401, let unauthorizedHeader = response.headers?["WWW-Authenticate"] {
            let regex = try! NSRegularExpression(pattern: "Basic realm=\"(.*)\"", options: [])
            let range = NSMakeRange(0, unauthorizedHeader.utf8.count)
            if let match = regex.firstMatchInString(unauthorizedHeader, options: [], range: range) {
                let realm = (unauthorizedHeader as NSString).substringWithRange(match.rangeAtIndex(1))
                onAuthenticationError(realm)
            }
        }
        completion(Result.Success(response))
    }
}
```

**Interceptors can be added to a ``BothamAPIClient`` instance or to all the ``BothamAPIClient`` instances at the same time. Interceptors added globally will be evaluated before and after every request independently of the ``BothamAPIClient`` instance. Interceptors added locally will be just appplied to the ``BothamAPIClient`` instance where you add those interceptors.**

```swift
let apiClient = BothamAPIClient(baseEndpoint: "https://api.github.com/repos/Karumi/")

//Add interceptors locally
apiClient.requestInterceptors.append(NSLogInterceptor())
apiClient.responseInterceptors.append(NSLogInterceptor())

//Add interceptors globally
BothamAPIClient.globalRequestInterceptors.append(NSLogInterceptor())
BothamAPIClient.globalResponseInterceptors.append(NSLogInterceptor())
```

###Retry requests:

To be able to retry a request add a ``BothamResponseInterceptor`` and return a ``BothamAPIClientError.RetryError`` when needed. ``BothamAPIClient`` will automatically retry the original request you sent.

```swift
class RetryInterceptor: BothamResponseInterceptor {

	func intercept(response: HTTPResponse, completion: (Result<HTTPResponse, BothamAPIClientError>) -> Void) {
            if response.statusCode == 401 {
                completion(Result.Failure(.RetryError))
            } else {
                completion(Result.Success(response))
            }
    }

}
```

**Be careful when using this mechanism as you can create an infinite loop or DOS yourself. Remember you should always call completion callback to do not break the ``BothamResponseInterceptor`` chain.**

License
-------

Copyright 2016 Karumi

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

[karumilogo]: https://cloud.githubusercontent.com/assets/858090/11626547/e5a1dc66-9ce3-11e5-908d-537e07e82090.png
