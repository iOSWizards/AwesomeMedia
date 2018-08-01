//
//  QuizAddProductNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 14/03/18.
//

import Foundation

class QuizAddProductNS {
    
    static let shared = QuizAddProductNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var quizAddProductRequest: URLSessionDataTask?
    
    func postQuizAddProduct(withUid uid: String, andProductId productId: String, forcingUpdate: Bool = false, response: @escaping (Bool, ErrorData?) -> Void) {
        
        quizAddProductRequest?.cancel()
        quizAddProductRequest = nil
        
        let url = ACConstants.shared.quizAddProduct + "?uid=" + uid + "&product_id=" + productId
        quizAddProductRequest = awesomeRequester.performRequestAuthorized(
            url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), forceUpdate: forcingUpdate, method: .POST, completion: { (data, error, responseType) in
                
                if error == nil {
                    self.quizAddProductRequest = nil
                    response(true, nil)
                } else {
                    self.quizAddProductRequest = nil
                    if let error = error {
                        response(false, error)
                        return
                    }
                    response(false, ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
}

