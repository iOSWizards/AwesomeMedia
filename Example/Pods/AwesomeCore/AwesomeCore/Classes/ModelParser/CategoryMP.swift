//
//  CategoryMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/09/17.
//

import Foundation

struct CategoryMP {
    
    static func parseCategoryFrom(_ categoriesJSON: [String: AnyObject]) -> ACCategory? {
        
        return ACCategory(imageUrl: AwesomeCoreParser.stringValue(categoriesJSON, key: "image_url"),
                          backgroundImageUrl: AwesomeCoreParser.stringValue(categoriesJSON, key: "background_image_url"),
                          name: AwesomeCoreParser.stringValue(categoriesJSON, key: "name"))
    }
    
    public static func parseCategoriesFrom(jsonObject: [String: AnyObject]) -> [ACCategory] {
        var categories = [ACCategory]()
        
        guard let categoriesDict = jsonObject["categories"] as? [[String: AnyObject]] else {
            return categories
        }
        
        for categoryDict in categoriesDict {
            if let t = parseCategoryFrom(categoryDict) {
                categories.append(t)
            }
        }
        
        return categories
    }
    
}
