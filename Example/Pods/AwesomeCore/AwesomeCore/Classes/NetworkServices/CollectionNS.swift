//
//  CollectionsNS.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 13/09/2017.
//

import Foundation

class CollectionNS {
    
    static let shared = CollectionNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastCollectionsRequest: URLSessionDataTask?
    
    func fetchCollections(forcingUpdate: Bool = false, response: @escaping ([ACCollection], ErrorData?) -> Void) {
        
        lastCollectionsRequest?.cancel()
        lastCollectionsRequest = nil
        
        lastCollectionsRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.libraryCollectionsURL, forceUpdate: forcingUpdate, completion: { (data, error, responseType) in
                
                if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                    self.lastCollectionsRequest = nil
                    response(CollectionMP.parseCollectionsFrom(jsonObject, key: "collections"), nil)
                } else {
                    self.lastCollectionsRequest = nil
                    if let error = error {
                        response([ACCollection](), error)
                        return
                    }
                    response([ACCollection](), ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
}
