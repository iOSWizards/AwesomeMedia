//
//  AcademyCategory.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 30/01/19.
//

import Foundation

public struct AcademyCategories: Codable {
    
    public var categories: [AcademyCategory]
    
}

public struct AcademyCategory: Codable {
    
    public var id: Int
    public var name: String
    public var ancestorId: Int?
    public var ancestorName: String?
    
}

// MARK: - Coding keys

extension AcademyCategory {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case ancestorId = "ancestor_id"
        case ancestorName = "ancestor_name"
    }
    
}
