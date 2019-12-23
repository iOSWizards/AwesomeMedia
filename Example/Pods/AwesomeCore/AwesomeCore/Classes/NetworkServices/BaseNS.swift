//
//  BaseNS.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 20/08/18.
//

import Foundation

class BaseNS {
    
    func dataFromCache(_ url: String, method: URLMethod = .GET, params: AwesomeCoreNetworkServiceParams, bodyDict: [String: AnyObject]? = nil) -> Data? {
        if params.contains(.shouldFetchFromCache) {
            if let body = bodyDict, let data = AwesomeCoreCacheManager.verifyForCache(urlRequest: URL(string: url)!, method: method, body: AwesomeCoreCacheManager.buildBody(body)) {
                return data
            } else if let data = AwesomeCoreCacheManager.verifyForCache(urlRequest: URL(string: url)!, method: method, body: nil) {
                return data
            }
            return nil
        }
        return nil
    }
    
    func saveToCache(_ url: String, method: URLMethod = .GET, bodyDict: [String: AnyObject]? = nil, data: Data?) {
        if let body = bodyDict {
            AwesomeCoreCacheManager.saveCache(urlRequest: URL(string: url)!, method: method, body: AwesomeCoreCacheManager.buildBody(body), data: data)
        } else {
            AwesomeCoreCacheManager.saveCache(urlRequest: URL(string: url)!, method: method, body: nil, data: data)
        }
    }
    
    func process(data: Data?, error: ErrorData?, response: @escaping (ErrorData?) -> Void) {
        if let jsonObject = data {
            let questError = QuestErrorMP.parseQuestErrorFrom(jsonObject)
            if questError.count > 0 {
                response(ErrorData(.generic, "An error occurred during your request."))
            } else {
                response(nil)
            }
        } else {
            if let error = error {
                response(error)
                return
            }
            response(ErrorData(.unknown, "response Data could not be parsed"))
        }
    }
    
}
