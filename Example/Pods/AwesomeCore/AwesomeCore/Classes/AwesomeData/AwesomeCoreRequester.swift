//
//  AwesomeCoreRequester.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 6/2/16.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

public enum URLMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
    case PATCH
}

public enum AwesomeError: String {
    case url
    case timeOut
    case unknown
    case cancelled
    case generic
    case noConnection
    case unauthorized
}

public struct ErrorData {
    public var errorType: AwesomeError = .unknown
    public var message: String = "Wow ... you better run away, something terrible happened 😱"
    
    public init(_ errorType: AwesomeError, _ message: String) {
        self.errorType = errorType
        self.message = message
    }
}

public enum AwesomeResponseType {
    case cached
    case fromServer
    case error
}

public typealias AwesomeResponse = (Data?, ErrorData?, AwesomeResponseType) -> Void

public class AwesomeCoreRequester: NSObject {
    
    lazy var session: URLSessionProtocol = URLSession.shared
    
    public init(cacheType: CacheType = .urlCache) {
        
    }
    
    // MARK:- Where the magic happens
    
    /*
     *   Fetch data from URL with NSUrlSession
     *   @param urlString: Url to fetch data form
     *   @param method: URL method to fetch data using URLMethod enum
     *   @param headerValues: Any header values to complete the request
     *   @param forceUpdate: When true it will force an update by fetching content from the given URL and storing it in URLCache.
     *   @param shouldCache: Cache fetched data, if on, it will check first for data in cache, then fetch if not found
     *   @param completion: Returns fetched NSData in a block
     */
    open func performRequest(
        _ urlString: String?,
        method: URLMethod? = .GET,
        bodyData: Data? = nil,
        headerValues: [[String]]? = nil,
        forceUpdate: Bool = false,
        shouldCache: Bool = false,
        timeoutAfter timeout: TimeInterval = AwesomeCore.timeoutTime,
        completion:@escaping AwesomeResponse) -> URLSessionDataTask? {
        
        guard let urlString = urlString else {
            completion(nil, ErrorData(.url, "urlString can't be nil."), .error)
            return nil
        }
        
        if urlString == "Optional(<null>)" {
            completion(nil, ErrorData(.url, "urlString can't be unwrapped."), .error)
            return nil
        }
        
        guard let url = URL(string: urlString) else{
            completion(nil, ErrorData(.url, "Could not build URL with the given urlString."), .error)
            return nil
        }
        
        // URL request configurations
        
        let urlRequest = NSMutableURLRequest(url: url)
        
        if let method = method {
            urlRequest.httpMethod = method.rawValue
        }
        
        if let bodyData = bodyData {
            urlRequest.httpBody = bodyData
        }
        
        if let headerValues = headerValues {
            for headerValue in headerValues {
                urlRequest.addValue(headerValue[0], forHTTPHeaderField: headerValue[1])
            }
        }
        
        if timeout > 0 {
            urlRequest.timeoutInterval = timeout
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let data = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            if let error = error {
                print("There was an error \(error)")
                
                let urlError = error as NSError
                if urlError.code == NSURLErrorTimedOut {
                    completion(nil, ErrorData(.timeOut, "Operation timmed out."), .error)
                } else if urlError.code == NSURLErrorNotConnectedToInternet {
                    completion(nil, ErrorData(.noConnection, "Could not stablish connection to the Internet"), .error)
                } else if urlError.code == URLError.cancelled.rawValue {
                    completion(nil, ErrorData(.cancelled, "this operation has been cancelled."), .error)
                } else {
                    completion(nil, ErrorData(.unknown, "Unknown falure."), .error)
                }
                
            }else{
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401  {
                    completion(nil, ErrorData(.unauthorized, "attempting to execute a request with an unauthorized token."), .error)
                } else {
                    completion(data, nil, .fromServer)
                }
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        data.resume()
        
        return data
    }
    
    /// Fetch data from URL with NSUrlSession
    ///
    /// - Parameters:
    ///   - urlString: URL to be fetched.
    ///   - method: method to fetch data using URLMethod enum.
    ///   - jsonBody: adds json (Dictionary) body to request.
    ///   - timeout: timeout option, _10 seconds by default_
    ///   - completion: closure in charge to receive the fetched data.
    /// - Returns: URLSessionDataTask that can be used to cancel the operation.
    public func performRequestAuthorized(
        _ urlString: String?,
        forceUpdate: Bool = false,
        shouldCache: Bool = true,
        headersParam: [String: String] = [:],
        method: URLMethod? = .GET,
        jsonBody: Any? = nil,
        timeoutAfter timeout: TimeInterval = AwesomeCore.timeoutTime,
        completion:@escaping AwesomeResponse) -> URLSessionDataTask? {
        
        var headers = [String: String]()
        
        for header in headersParam {
            headers[header.key] = header.value
        }
        
        if AwesomeCore.shared.bearerToken.count > 7 {
            headers["Authorization"] = AwesomeCore.shared.bearerToken
        }
        
        headers["Timezone"] = TimeZone.current.identifier
        
        if AwesomeCore.shared.isOICD {
            headers["x-mv-auth0"] = "mobile"
        }
        if AwesomeCore.shared.app == .mindvalley {
            headers["x-mv-app"] = "mv-ios"
        }
        
        AwesomeCore.executeBlock {
            _ = self.performRequest(
                urlString,
                method: method,
                forceUpdate: forceUpdate,
                shouldCache: shouldCache,
                jsonBody: jsonBody,
                headers: headers,
                timeoutAfter: timeout,
                completion: completion
            )
        }
        
        return nil
    }
    
    public func performRequest(
        _ urlString: String?,
        forceUpdate: Bool = false,
        shouldCache: Bool = true,
        method: URLMethod? = .GET,
        jsonBody: Any? = nil,
        timeoutAfter timeout: TimeInterval = AwesomeCore.timeoutTime,
        completion:@escaping AwesomeResponse) -> URLSessionDataTask? {
        
        return performRequest(
            urlString,
            method: method,
            forceUpdate: forceUpdate,
            shouldCache: shouldCache,
            jsonBody: jsonBody,
            headers: [:],
            timeoutAfter: timeout,
            completion: completion
        )
    }
    
}

// MARK: - Custom Calls

extension AwesomeCoreRequester {
    
    /*
     *   Fetch data from URL with NSUrlSession
     *   @param urlString: Url to fetch data form
     *   @param body: adds body to request, can be of any kind
     *   @param completion: Returns fetched NSData in a block
     */
    public func performRequest(
        _ urlString: String?,
        body: String?,
        timeoutAfter timeout: TimeInterval = AwesomeCore.timeoutTime,
        completion:@escaping AwesomeResponse) -> URLSessionDataTask? {
        
        if let body = body {
            return performRequest(
                urlString, method: nil,
                bodyData: body.data(using: String.Encoding.utf8),
                headerValues: nil,
                shouldCache: false,
                timeoutAfter: timeout,
                completion: completion
            )
        }
        return performRequest(
            urlString, method: nil,
            bodyData: nil,
            headerValues: nil,
            shouldCache: false,
            timeoutAfter: timeout,
            completion: completion
        )
    }
    
    /*
     *   Fetch data from URL with NSUrlSession
     *   @param urlString: Url to fetch data form
     *   @param method: URL method to fetch data using URLMethod enum
     *   @param jsonBody: adds json (Dictionary) body to request
     *   @param completion: Returns fetched NSData in a block
     */
    public func performRequest(
        _ urlString: String?,
        method: URLMethod?,
        jsonBody: Any?,
        timeoutAfter timeout: TimeInterval = AwesomeCore.timeoutTime,
        completion:@escaping AwesomeResponse) -> URLSessionDataTask? {
        
        var data: Data?
        var headerValues = [[String]]()
        if let jsonBody = jsonBody as? [String: AnyObject] {
            do {
                try data = JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
                headerValues.append(["application/json", "Content-Type"])
                headerValues.append(["application/json", "Accept"])
            } catch{
                NSLog("Error unwraping json object")
            }
        } else if let jsonBody = jsonBody as? Data {
            data = jsonBody
            headerValues.append(["application/json", "Content-Type"])
            headerValues.append(["application/json", "Accept"])
        }
        
        return performRequest(
            urlString,
            method: method,
            bodyData: data,
            headerValues: headerValues,
            shouldCache: false,
            timeoutAfter: timeout,
            completion: completion
        )
    }
    
    /*
     *   Fetch data from URL with NSUrlSession
     *   @param urlString: Url to fetch data form
     *   @param method: URL method to fetch data using URLMethod enum
     *   @param jsonBody: adds json (Dictionary) body to request
     *   @param headers: adds headers to the request
     *   @param timeout: adds the request timeout
     *   @param completion: Returns fetched NSData in a block
     */
    public func performRequest(
        _ urlString: String?,
        method: URLMethod? = .GET,
        forceUpdate: Bool = false,
        shouldCache: Bool = true,
        jsonBody: Any? = nil,
        headers: [String: String],
        timeoutAfter timeout: TimeInterval = AwesomeCore.timeoutTime,
        completion:@escaping AwesomeResponse) -> URLSessionDataTask? {
        
        var data: Data?
        var headerValues = [[String]]()
        
        if let jsonBody = jsonBody as? [String: AnyObject] {
            do {
                try data = JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
                headerValues.append(["application/json", "Content-Type"])
                headerValues.append(["application/json", "Accept"])
            } catch{
                NSLog("Error unwraping json object")
            }
        } else if let jsonBody = jsonBody as? Data {
            data = jsonBody
            headerValues.append(["application/json", "Content-Type"])
            headerValues.append(["application/json", "Accept"])
        }
        
        for (key, value) in headers {
            headerValues.append([value, key])
        }
        
        return performRequest(
            urlString,
            method: method,
            bodyData: data,
            headerValues: headerValues,
            forceUpdate: forceUpdate,
            shouldCache: shouldCache,
            timeoutAfter: timeout,
            completion: completion
        )
    }
    
}

// MARK: - Testing

public protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
