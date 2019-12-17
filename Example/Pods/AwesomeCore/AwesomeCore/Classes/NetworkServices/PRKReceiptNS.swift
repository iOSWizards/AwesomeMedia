//
//  File.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 8/30/18.
//

import Foundation

class PRKReceiptNS: BaseNS {
    
    static let shared = PRKReceiptNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    func confirmReceipt(receipt: String, subscription: Bool, email: String, params: AwesomeCoreNetworkServiceParams, _ response:@escaping (ErrorData?) -> Void) {
        let jsonBody: [String: AnyObject] = ["access_token": AwesomeCore.shared.bearerToken as AnyObject,
                                             "email": email as AnyObject,
                                             "receipt_data": receipt as AnyObject,
                                             "subscription": subscription as AnyObject]
        
        _ = requester.performRequestAuthorized(
            ACConstants.shared.prkIAPReceiptURL, forceUpdate: true, method: .POST, jsonBody: jsonBody, completion: { (data, error, responseType) in
                
                if let jsonObject = AwesomeCoreParser.jsonObject(data) {
                    print("Confirmed receipt: \(jsonObject)")
                    
                    if "\(jsonObject)".contains("error_description") {
                        if let message = jsonObject["error_description"] as? String {
                            response(ErrorData(.unknown, message))
                        } else {
                            response(error)
                        }
                    } else {
                        response(nil)
                    }
                } else {
                    response(nil)
                }
        })
    }
    
    func user(withId userId: String, params: AwesomeCoreNetworkServiceParams = .forcing, response: @escaping (PRKUser?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (PRKUser?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let prkUser: PRKUser? = PRKUserMP.parseUser(data)
            
            response(prkUser, nil)
            
            return true
        }
        
        let url: String = "\(ACConstants.shared.prkIAPUsersURL)\(userId)"
        let method: URLMethod = URLMethod.GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params), response: response)
        }
        
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, data: data)
                }
        })
    }
    
    func productsForUser(withId userId: String, params: AwesomeCoreNetworkServiceParams = .forcing, response: @escaping (PRKUser?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (PRKUser?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let products = ProductsForUserMP.parse(data)
            let prkUser: PRKUser? = PRKUser(id: nil, uid: nil, email:  nil, createdAt: nil, productIds: products?.data, purchases: nil, inAppPurchaseReceipts: nil)
            
            response(prkUser, nil)
            
            return products != nil
        }
        
        let url: String = ACConstants.shared.osirisProductsOwnedByUser
        let method: URLMethod = URLMethod.GET
        
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, data: data)
                }
        })
    }
}
