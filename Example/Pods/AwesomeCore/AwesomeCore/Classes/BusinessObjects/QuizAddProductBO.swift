//
//  QuizAddProductBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 14/03/18.
//

import Foundation

public struct QuizAddProductBO {
    
    static var quizAddProductNS = QuizAddProductNS.shared
    public static var shared = QuizAddProductBO()
    
    private init() {}
    
    public static func postQuizAddProduct(withUid uid: String, andProductId productId: String, forcingUpdate: Bool = false, response: @escaping (Bool, ErrorData?) -> Void) {
        quizAddProductNS.postQuizAddProduct(withUid: uid, andProductId: productId, forcingUpdate: forcingUpdate) { (success, error) in
            DispatchQueue.main.async {
                response(success, error)
            }
        }
    }
}

