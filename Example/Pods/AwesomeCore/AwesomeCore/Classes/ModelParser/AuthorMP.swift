//
//  AuthorMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/07/17.
//

import Foundation

public struct AuthorMP {
    
    static func parseAuthorsFrom(jsonObject: [String: AnyObject], key: String) -> [ACAuthor] {
        var authors = [ACAuthor]()
        guard let jsonAuthors = jsonObject[key] as? [[String: AnyObject]] else {
            return authors
        }
        for json in jsonAuthors {
            authors.append(parseAuthorFrom(jsonObject: json) )
        }
        return authors
    }
    
    public static func parseAuthorFrom(jsonObject: [String: AnyObject]) -> ACAuthor {
        return ACAuthor(
            authorId: AwesomeCoreParser.intValue(jsonObject, key: "id"),
            name: ParserCoreHelper.parseString(jsonObject, key: "name"),
            assetCoverUrl: ParserCoreHelper.parseString(jsonObject, key: "asset_cover_url")
        )
    }
    
}
