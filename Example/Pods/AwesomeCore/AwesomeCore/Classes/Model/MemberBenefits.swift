//
//  MemberBenefits.swift
//  AwesomeCore
//
//  Created by Emmanuel on 09/05/2018.
//

import Foundation

public struct MemberBenefits: Codable {
    public let benefits: [Benefits]
}

public struct Benefits: Codable {
    
    public let type: String
    public let bgImageUrl: String
    public let themeColor: String
    public let title: String
    public let url: String
    public let academyId: String?
    public let courseId: String?
    public let popupCopy: String?
    public let passphrase: String?
    public let groupId: String?
    
    
    init(type: String,
         bgImageUrl: String,
         themeColor: String,
         title: String,
         url: String,
         academyId: String? = nil,
         courseId: String? = nil,
         popupCopy: String? = nil,
         passphrase: String? = nil,
         groupId: String? = nil) {
        
        self.type = type
        self.bgImageUrl = bgImageUrl
        self.themeColor = themeColor
        self.title = title
        self.url = url
        self.academyId = academyId
        self.courseId = courseId
        self.popupCopy = popupCopy
        self.passphrase = passphrase
        self.groupId = groupId
    }
    
}

// MARK: - Coding keys

extension Benefits {
    private enum CodingKeys: String, CodingKey {
        case type
        case bgImageUrl = "bg_image_url"
        case themeColor = "theme_color"
        case title
        case url
        case academyId = "academy_id"
        case courseId = "course_id"
        case popupCopy = "popup_copy"
        case passphrase
        case groupId = "group_id"
    }
}

// MARK: - Equatable

extension MemberBenefits {
    public static func ==(lhs: MemberBenefits, rhs: MemberBenefits) -> Bool {
        if lhs.benefits.first?.url != rhs.benefits.first?.url  {
            return false
        }
        return true
    }
}
