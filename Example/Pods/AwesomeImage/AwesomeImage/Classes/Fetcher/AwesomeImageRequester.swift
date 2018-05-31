//
//  AwesomeImageRequester.swift
//  AwesomeImage
//
//  Created by Evandro Harrison Hoffmann on 6/2/16.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

public enum URLMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
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

public class AwesomeImageRequester: NSObject {
    
    lazy var session: URLSessionProtocol = URLSession.shared
    let cacheType: CacheType
    var cacheManager: AwesomeImageCacheManager!
    
    init(cacheType: CacheType = .urlCache) {
        self.cacheType = cacheType
        if cacheType == .nsCache {
            self.cacheManager = AwesomeImageCacheManager()
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
        timeoutAfter timeout: TimeInterval = 0,
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
                if let data = AwesomeImageCacheManager.getCachedObject(urlRequest as URLRequest) {
                    completion(data, nil, .cached)
                    return nil
                }
            } else {
                if let data = cacheManager.objectForKey(urlRequest.url?.path ?? "") {
                    completion(data as? Data, nil, .cached)
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
                            AwesomeImageCacheManager.cacheObject(urlRequest as URLRequest, response: response, data: data)
                        } else if let data = data {
                            self.cacheManager.cacheObject(data, forKey: urlRequest.url?.path ?? "")
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
    
}

// MARK: - Custom Calls

extension AwesomeImageRequester {
    
    /*
     *   Fetch data from URL with NSUrlSession
     *   @param urlString: Url to fetch data form
     *   @param body: adds body to request, can be of any kind
     *   @param completion: Returns fetched NSData in a block
     */
    public func performRequest(
        _ urlString: String?,
        body: String?,
        timeoutAfter timeout: TimeInterval = 0,
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
        timeoutAfter timeout: TimeInterval = 0,
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
        timeoutAfter timeout: TimeInterval = 0,
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
    
}

// MARK: - Testing

public protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
