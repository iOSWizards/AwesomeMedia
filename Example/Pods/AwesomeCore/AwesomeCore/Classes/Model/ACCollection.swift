//
//  ACCollection.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 13/09/2017.
//

import Foundation

public struct ACCollection: Codable {
    
    public let academyId: Int
    public let awcProductId: String
    public let title: String
    public let productUrl: String
    public let themeColor: String
    public let coursesCovers: [String]
    
}
