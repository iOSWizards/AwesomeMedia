//
//  BubbleQuizSubmitAnswersNS.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/02/19.
//

import Foundation

class BubbleQuizSubmitAnswersNS: BaseNS {
    
    static let shared = BubbleQuizSubmitAnswersNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    func submitAnswers(answers: [Int], distinctId: String, cardLimit: Bool = false, params: AwesomeCoreNetworkServiceParams, _ response:@escaping (BubbleQuizSubmitAnswersResponse?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (BubbleQuizSubmitAnswersResponse?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let submitAnswersResponse = BubbleQuizSubmitAnswersMP.parse(data)
            response(submitAnswersResponse, nil)
            return submitAnswersResponse != nil
        }
        
        let jsonBody: [String: AnyObject] = BubbleQuizGraphQLModel.submitAnswers(distinctId, answerIds: answers, cardLimit: cardLimit)
        let method: URLMethod = .POST
        let url: String = ACConstants.shared.questsURL
        
        //        if params.contains(.shouldFetchFromCache) {
        //            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: jsonBody), response: response)
        //        }
        
        _ = requester.performRequest(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
}
