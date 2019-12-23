//
//  QuestReceiptNS.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/7/17.
//

import Foundation

class QuestPurchaseNS {
    
    static let shared = QuestPurchaseNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastVerifyReceiptRequest: URLSessionDataTask?
    var lastAddPurchaseRequest: URLSessionDataTask?
    
    let method: URLMethod = .POST
    let url = ACConstants.shared.questsURL
    
    func verifyReceipt(withReceipt receipt: String, response: @escaping (Bool, ErrorData?) -> Void) {
        
        lastVerifyReceiptRequest?.cancel()
        lastVerifyReceiptRequest = nil
        
        lastVerifyReceiptRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: QuestPurchaseGraphQLModel.mutateVerifyIAPReceipt(receipt), completion: { (data, error, responseType) in
                if data != nil {
                    self.lastVerifyReceiptRequest = nil
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments), let jsonObject = json as? [String: Any] {
                        if jsonObject.keys.contains("errors") {
                            response(false, nil)
                        } else {
                            response(true, nil)
                        }
                    } else {
                        response(false, nil)
                    }
                } else {
                    self.lastVerifyReceiptRequest = nil
                    if let error = error {
                        response(false, error)
                        return
                    }
                    response(false, ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
    
    func addPurchase(withProductId productId: String, response: @escaping (Bool, ErrorData?) -> Void) {
        
        lastAddPurchaseRequest?.cancel()
        lastAddPurchaseRequest = nil
        
        lastAddPurchaseRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: QuestPurchaseGraphQLModel.mutateAddPurchase(withId: productId), completion: { (data, error, responseType) in
                if data != nil {
                    self.lastAddPurchaseRequest = nil
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments), let jsonObject = json as? [String: Any] {
                        if jsonObject.keys.contains("errors") {
                            response(false, nil)
                        } else {
                            response(true, nil)
                        }
                    } else {
                        response(false, nil)
                    }
                } else {
                    self.lastAddPurchaseRequest = nil
                    if let error = error {
                        response(false, error)
                        return
                    }
                    response(false, ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
}
