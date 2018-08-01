//
//  AuthorDA.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 04/08/2017.
//

//import Foundation
//
//class AuthorDA {
//    
//    func parseToCoreData(_ author: ACAuthor) -> CDAuthor {
//        
//        let p = NSPredicate(
//            format: "authorId == %d AND academy.academyId == %d",
//            author.authorId, author.academyId
//        )
//        
//        let cdAuthor = CDAuthor.getObjectAC(withContext: AwesomeCoreDataAccess.shared.backgroundContext, predicate: p, createIfNil: true) as! CDAuthor
//        
//        cdAuthor.authorId = Int32(author.authorId)
//        cdAuthor.name = author.name
//        cdAuthor.assetCoverUrl = author.assetCoverUrl
//        
//        return cdAuthor
//    }
//    
//    func parseToCoreData(_ author: ACAuthor, completion: @escaping (CDAuthor?) -> Void) {
//        AwesomeCoreDataAccess.shared.performInBackground {
//            let p = NSPredicate(
//                format: "authorId == %d AND academy.academyId == %d",
//                author.authorId, author.academyId
//            )
//            
//            let cdAuthor = CDAuthor.getObjectAC(predicate: p, createIfNil: true) as! CDAuthor
//            
//            cdAuthor.authorId = Int32(author.authorId)
//            cdAuthor.name = author.name
//            cdAuthor.assetCoverUrl = author.assetCoverUrl
//            
//            completion(cdAuthor)
//        }
//    }
//    
//    func parseFromCoreData(_ cdAuthor: CDAuthor) -> ACAuthor {
//        return ACAuthor(
//            authorId: Int(cdAuthor.authorId),
//            name: cdAuthor.name ?? "",
//            assetCoverUrl: cdAuthor.assetCoverUrl,
//            academyId: Int(cdAuthor.academy?.academyId ?? -1)
//        )
//    }
//    
//    func extractAuthors(_ authors: [ACAuthor]) -> NSSet {
//        var authorSet = NSSet()
//        for author in authors {
//            authorSet = authorSet.adding(parseToCoreData(author)) as NSSet
//        }
//        return authorSet
//    }
//    
//    func extractCDAuthors(_ authors: NSSet?) -> [ACAuthor] {
//        var arAuthor = [ACAuthor]()
//        guard let authors = authors else {
//            return arAuthor
//        }
//        
//        for cdAuthor in authors {
//            let a = parseFromCoreData(cdAuthor as! CDAuthor)
//            arAuthor.append(a)
//        }
//        return arAuthor
//    }
//    
//}
