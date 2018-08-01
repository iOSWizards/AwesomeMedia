//
//  AcademyMP.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 29/08/2017.
//

import Foundation

struct AcademyMP {
    
    static func parseAcademiesFrom(_ academyJSON: [String: AnyObject], key: String) -> [ACAcademy] {
        var academies = [ACAcademy]()
        guard let academiesJSON = academyJSON[key] as? [[String: AnyObject]] else {
            return academies
        }
        for academyDic in academiesJSON {
            academies.append(parseAcademyFrom(academyDic))
        }
        return academies
    }
    
    static func parseAcademyFrom(_ academyJSON: [String: AnyObject]) -> ACAcademy {
        return ACAcademy(
            id: AwesomeCoreParser.intValue(academyJSON, key: "id"),
            domain: AwesomeCoreParser.stringValue(academyJSON, key: "domain"),
            name: AwesomeCoreParser.stringValue(academyJSON, key: "name"),
            type: AwesomeCoreParser.stringValue(academyJSON, key: "type"),
            subscription: AwesomeCoreParser.boolValue(academyJSON, key: "subscription"),
            awcProductId: AwesomeCoreParser.stringValue(academyJSON, key: "awc_product_id"),
            themeColor: AwesomeCoreParser.stringValue(academyJSON, key: "theme_color"),
            tribeLearnTribeId: AwesomeCoreParser.stringValue(academyJSON, key: "tribelearn_tribe_id"),
            courseOrdering: AwesomeCoreParser.stringValue(academyJSON, key: "course_ordering"),
            authors: AuthorMP.parseAuthorsFrom(jsonObject: academyJSON, key: "authors"),
            numberOfCourses: AwesomeCoreParser.intValue(academyJSON, key: "number_of_courses"),
            featuredCourseId: AwesomeCoreParser.intValue(academyJSON, key: "featured_course_id"),
            coverPhotoURL: AwesomeCoreParser.stringValue(academyJSON, key: "cover_photo_url"),
            courseCoverImages: AwesomeCoreParser.stringValues(academyJSON, key: "course_cover_images"),
            purchased: AwesomeCoreParser.boolValue(academyJSON, key: "purchased"),
            purchasedAt: ParserCoreHelper.parseDate(
                dateString: ParserCoreHelper.parseString(academyJSON, key: "purchased_at")
            )
        )
    }
    
}
