//
//  UserProfileBO.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 04/09/2017.
//

import Foundation

protocol UserProfileBOProtocol {
    static func fetchUserProfile(forcingUpdate: Bool, response: @escaping (UserProfile?, ErrorData?) -> Void)
    func fetchUserProfileImpl(forcingUpdate: Bool, response: @escaping (UserProfile?, ErrorData?) -> Void)
    func syncUserProfile(forcingUpdate: Bool)
}

/// Use this enum to register for all notifications provided by UserProfileBO,
/// it also provides the keys needed to extract content from the userInfo hashMap
/// object **[AnyHashable : Any]?**, part of the Notification.
///
/// - didFinishSyncUserProfile: fired once a user profile synced locally has
///the **Last Read Course**. This object can be extracted from _userInfo_ using the enum property: **lastReadCourse**
/// - lastReadCourse: key used to extract ACCourse from the notification.
public enum UserProfileBONotifications: String {
    case didFinishSyncUserProfile
}

public struct UserProfileBO: UserProfileBOProtocol {
    
    static var userProfileNS = UserProfileNS.shared
//    static var courseDA = CourseDA.shared
    
    public static func fetchUserProfile(forcingUpdate: Bool, response: @escaping (UserProfile?, ErrorData?) -> Void) {
        userProfileNS.fetchUserProfile() { (userProfile, error) in
            DispatchQueue.main.async {
                response(userProfile, error)
            }
        }
    }
    
    public static func fetchQuestUserProfile(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (UserProfile?, ErrorData?) -> Void) {
        userProfileNS.fetchQuestUserProfile(params: params) { (userProfile, error) in
            DispatchQueue.main.async {
                response(userProfile, error)
            }
        }
    }
    
    public static func uploadUserProfilePicture(usingPicture picture: UIImage, response: @escaping ([String: AnyObject]?, ErrorData?) -> Void) {
        userProfileNS.uploadUserProfilePicture(usingPicture: picture) { (dictionary, error) in
            DispatchQueue.main.async {
                response(dictionary, error)
            }
        }
    }
    
    public static func updateProfile(_ email: String, firstName: String, lastName: String, response: @escaping (UserProfile?, ErrorData?) -> Void) {
        userProfileNS.updateProfile(withEmail: email, firstName: firstName, lastName: lastName) { (profile, error) in
            DispatchQueue.main.async {
                response(profile, error)
            }
        }
    }
    
    public static func fetchHomeUserProfile(forcingUpdate: Bool, response: @escaping (HomeUserProfile?, ErrorData?) -> Void) {
        userProfileNS.fetchHomeUserProfile(forcingUpdate: forcingUpdate) { (userProfile, error) in
            DispatchQueue.main.async {
                response(userProfile, error)
            }
        }
    }
    
    public static func updateHomeUserProfile(profileDic: [String: Any], response: @escaping (HomeUserProfile?, ErrorData?) -> Void) {
        userProfileNS.updateHomeUserProfile(profileDic: profileDic) { (userProfile, error) in
            DispatchQueue.main.async {
                response(userProfile, error)
            }
        }
    }
    
    func syncUserProfile(forcingUpdate: Bool) {
        fetchUserProfileImpl(forcingUpdate: forcingUpdate) { (userProfile, error) in
            if let userProfile = userProfile, let course = userProfile.lastReadCourse {
                let notification = NSNotification.Name(UserProfileBONotifications.didFinishSyncUserProfile.rawValue)
                NotificationCenter.default.post(
                    name: notification,
                    object: self,
                    userInfo: [UserProfileBONotifications.didFinishSyncUserProfile.rawValue: course]
                )
            }
        }
    }
    
    func fetchUserProfileImpl(forcingUpdate: Bool, response: @escaping (UserProfile?, ErrorData?) -> Void) {
        UserProfileBO.fetchUserProfile(forcingUpdate: forcingUpdate, response: response)
    }
}

