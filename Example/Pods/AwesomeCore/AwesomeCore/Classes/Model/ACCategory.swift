//
//  Category.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/09/17.
//

import Foundation

public struct ACCategory: Codable {
    
    public let imageUrl: String
    public let backgroundImageUrl: String
    public let name: String
    
    init(imageUrl: String,
        backgroundImageUrl: String,
        name: String) {
        
        self.imageUrl = imageUrl
        self.backgroundImageUrl = backgroundImageUrl
        self.name = name
    }
}
