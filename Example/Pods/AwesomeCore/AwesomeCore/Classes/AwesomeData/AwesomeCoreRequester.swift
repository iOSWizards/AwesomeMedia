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
    let cacheType: CacheType
    var cacheManager: AwesomeCoreCacheManager!
    
    init(cacheType: CacheType = .urlCache) {
        self.cacheType = cacheType
        if cacheType == .realm {
            self.cacheManager = AwesomeCoreCacheManager()
        } else {
            self.cacheManager = nil
        }
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
        
        // check if file been cached already
        if forceUpdate == false && shouldCache {
            if self.cacheManager == nil {
                if let data = AwesomeCoreCacheManager.getCachedObject(urlRequest as URLRequest) {
                    completion(data, nil, .cached)
                    return nil
                }
            } else {
                let url = buildURLCacheKey(urlRequest.url, method: method, bodyData: bodyData, headerValues: headerValues)
                if let data = cacheManager.data(forKey: url) {
                    completion(data, nil, .cached)
                    return nil
                }
            }
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
                    if shouldCache || forceUpdate {
                        if self.cacheManager == nil {
                            AwesomeCoreCacheManager.cacheObject(urlRequest as URLRequest, response: response, data: data)
                        } else if let data = data {
                            let url = self.buildURLCacheKey(urlRequest.url, method: method, bodyData: bodyData, headerValues: headerValues)
                            self.cacheManager.cache(data, forKey: url)
                        }
                    }
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
        method: URLMethod? = .GET,
        jsonBody: [String: AnyObject]? = nil,
        timeoutAfter timeout: TimeInterval = AwesomeCore.timeoutTime,
        completion:@escaping AwesomeResponse) -> URLSessionDataTask? {
        
        var headers = [ "Authorization": AwesomeCore.shared.bearerToken ]
        
        headers["Timezone"] = TimeZone.current.identifier
        
        if AwesomeCore.shared.isOICD {
            headers["x-mv-auth0"] = "mobile"
        }
        
        return performRequest(
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
    
    public func performRequest(
        _ urlString: String?,
        forceUpdate: Bool = false,
        shouldCache: Bool = true,
        method: URLMethod? = .GET,
        jsonBody: [String: AnyObject]? = nil,
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
        jsonBody: [String: AnyObject]?,
        timeoutAfter timeout: TimeInterval = AwesomeCore.timeoutTime,
        completion:@escaping AwesomeResponse) -> URLSessionDataTask? {
        
        var data: Data?
        var headerValues = [[String]]()
        if let jsonBody = jsonBody {
            do {
                try data = JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
                headerValues.append(["application/json", "Content-Type"])
                headerValues.append(["application/json", "Accept"])
            } catch{
                NSLog("Error unwraping json object")
            }
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
        jsonBody: [String: AnyObject]? = nil,
        headers: [String: String],
        timeoutAfter timeout: TimeInterval = AwesomeCore.timeoutTime,
        completion:@escaping AwesomeResponse) -> URLSessionDataTask? {
        
        var data: Data?
        var headerValues = [[String]]()
        
        if let jsonBody = jsonBody {
            do {
                try data = JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
                headerValues.append(["application/json", "Content-Type"])
                headerValues.append(["application/json", "Accept"])
            } catch{
                NSLog("Error unwraping json object")
            }
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
    
    // Perform Request with Any instead of AnyObject
    /* Because Bool using AnyObject resolves to 0 or 1.*/
    public func performRequest(
        _ urlString: String?,
        method: URLMethod? = .GET,
        forceUpdate: Bool = false,
        shouldCache: Bool = true,
        jsonBody: [String: Any]? = nil,
        headers: [String: String],
        timeoutAfter timeout: TimeInterval = AwesomeCore.timeoutTime,
        completion:@escaping AwesomeResponse) -> URLSessionDataTask? {
        
        var data: Data?
        var headerValues = [[String]]()
        
        if let jsonBody = jsonBody {
            do {
                try data = JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
                headerValues.append(["application/json", "Content-Type"])
                headerValues.append(["application/json", "Accept"])
            } catch{
                NSLog("Error unwraping json object")
            }
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
 
    // MARK: - Helpers
    
    private func buildURLCacheKey(_ url: URL?,
                                  method: URLMethod?,
                                  bodyData: Data?,
                                  headerValues: [[String]]?) -> String {
        
        if let bodyData = bodyData, let urlString = url?.absoluteString, let method = method, let headerValues = headerValues {
            let hashValue = HashBuilder(data: bodyData, method: method, url: urlString, headers: headerValues).hashValue
            return urlString + "?keyHash=\(hashValue)"
        }
        return url?.absoluteString ?? ""
    }
    
}

// MARK: - Testing

public protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
