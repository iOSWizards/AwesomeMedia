//
//  AcademyCategoryBO.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 30/01/19.
//

import Foundation

public struct AcademyCategoryBO {
    
    static var academyCategoryNS = AcademyCategoryNS.shared
    
    private init() {}
    
    public static func getCategories(params: AwesomeCoreNetworkServiceParams = .standard, academy: Int, response: @escaping ([AcademyCategory], ErrorData?) -> Void) {
        academyCategoryNS.getCategories(params: params, academyId: academy) { (categories, error) in
            DispatchQueue.main.async {
                response(categories, error)
            }
        }
    }
    
}
