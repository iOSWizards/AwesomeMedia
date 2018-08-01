//
//  CollectionMP.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 13/09/2017.
//

import Foundation

struct CollectionMP {
    
    static func parseCollectionsFrom(_ collectionJSON: [String: AnyObject], key: String) -> [ACCollection] {
        var collections = [ACCollection]()
        guard let collectionsJSON = collectionJSON[key] as? [[String: AnyObject]] else {
            return collections
        }
        for collectionJSON in collectionsJSON {
            collections.append(parseCollectionFrom(collectionJSON))
        }
        return collections
    }
    
    static func parseCollectionFrom(_ collectionJSON: [String: AnyObject]) -> ACCollection {
        return ACCollection(
            academyId: AwesomeCoreParser.intValue(collectionJSON, key: "academy_id"),
            awcProductId: AwesomeCoreParser.stringValue(collectionJSON, key: "awc_product_id"),
            title: AwesomeCoreParser.stringValue(collectionJSON, key: "title"),
            productUrl: AwesomeCoreParser.stringValue(collectionJSON, key: "product_url"),
            themeColor: AwesomeCoreParser.stringValue(collectionJSON, key: "theme_color"),
            coursesCovers: AwesomeCoreParser.stringValues(collectionJSON, key: "courses_covers")
        )
    }
    
}
