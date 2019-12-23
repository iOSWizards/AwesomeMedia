//
//  CollectionsNS.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 13/09/2017.
//

import Foundation

class CollectionNS: BaseNS {
    
    static let shared = CollectionNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var lastCollectionsRequest: URLSessionDataTask?
    
    func fetchCollections(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([ACCollection], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([ACCollection], ErrorData?) -> Void ) -> Bool {
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.lastCollectionsRequest = nil
                response(CollectionMP.parseCollectionsFrom(jsonObject, key: "collections"), nil)
                return true
            } else {
                self.lastCollectionsRequest = nil
                if let error = error {
                    response([ACCollection](), error)
                    return false
                }
                response([ACCollection](), ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.libraryCollectionsURL
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        lastCollectionsRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: nil, data: data)
                }
        })
    }
}
