//
//  UserProfileMP.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 04/09/2017.
//

import Foundation

struct UserProfileMP {
    
    static func parseUserProfileFrom(_ userProfileJSON: [String: AnyObject]) -> UserProfile? {
        
        guard let userJSON = userProfileJSON["user"] as? [String: AnyObject] else {
            return nil
        }
        
        var course: ACCourse?
        if let courseJSON = userJSON["last_course_read"] as? [String: AnyObject] {
            course = CourseMP.extractCourse(courseJSON)
        }
        
        return UserProfile(
            email: AwesomeCoreParser.stringValue(userJSON, key: "email"),
            firstName: AwesomeCoreParser.stringValue(userJSON, key: "first_name"),
            lastName: AwesomeCoreParser.stringValue(userJSON, key: "last_name"),
            currentSignInAt: ParserCoreHelper.parseDateFormatterSSSZ(userJSON, key: "current_sign_in_at"),
            lastSignInAt: ParserCoreHelper.parseDateFormatterSSSZ(userJSON, key: "last_sign_in_at"),
            lastSignInIp: AwesomeCoreParser.stringValue(userJSON, key: "last_sign_in_ip"),
            enrollmentsCount: AwesomeCoreParser.intValue(userJSON, key: "enrollments_count"),
            signInCount: AwesomeCoreParser.intValue(userJSON, key: "sign_in_count"),
            createdAt: ParserCoreHelper.parseDateFormatterSSSZ(userJSON, key: "created_at"),
            updatedAt: ParserCoreHelper.parseDateFormatterSSSZ(userJSON, key: "updated_at"),
            lastReadCourse: course
        )
    }
    
    static func parseUserProfileFrom(_ UserProfileJSON: Data) -> UserProfile? {
        var userProfile: UserProfile?
        do {
            let decoded = try JSONDecoder().decode(UserProfileDataKey.self, from: UserProfileJSON)
            userProfile = decoded.data.profile
        } catch {
            print("\(#function) error: \(error)")
        }
        return userProfile
    }
    
    static func parseHomeUserProfileFrom(_ userProfileJSON: Data) -> HomeUserProfile? {
        var userProfile: HomeUserProfile?
        do {
            let decoded = try JSONDecoder().decode(HomeUserProfileDataKey.self, from: userProfileJSON)
            userProfile = decoded.user
        } catch {
            print("\(#function) error: \(error)")
        }
        return userProfile
    }
}
