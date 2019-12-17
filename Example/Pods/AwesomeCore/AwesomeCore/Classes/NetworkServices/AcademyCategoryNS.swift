//
//  AcademyCategoryNS.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 30/01/19.
//

import Foundation

class AcademyCategoryNS: BaseNS {
    
    static let shared = AcademyCategoryNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    func getCategories(params: AwesomeCoreNetworkServiceParams, academyId: Int, _ response:@escaping ([AcademyCategory], ErrorData?) -> Void) {
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.academyCategory, with: academyId)
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: .GET, completion: { (data, error, responseType) in
                guard let data = data else {
                    response([], nil)
                    return
                }
                
                if let error = error {
                    print("Error fetching from API: \(error.message)")
                    response([], error)
                    return
                }
                
                let categories = AcademyCategoryMP.parse(data)
                response(categories, nil)
        })
    }
    
}

