//
//  BrazeHelper.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/06/18.
//

import Foundation
import Appboy_iOS_SDK
import AwesomeCore

struct BrazeHelper {
    
    static func track(_ eventName: String, with params: AwesomeTrackingDictionary) {
        Appboy.sharedInstance()?.logCustomEvent(eventName, withProperties: params.stringLiteral())
    }
    
    static func trackFacebookUser(_ user: HomeUserProfile) {
        let dict = ["id": user.facebookId ?? "",
                    "cover": user.photo ?? "",
                    "email": user.email ?? "",
                    "first_name": user.firstName ?? "",
                    "last_name": user.lastName ?? "",
                    "gender": user.gender ?? ""]
        let facebookUser: ABKFacebookUser = ABKFacebookUser(facebookUserDictionary: dict, numberOfFriends: -1, likes: nil)
        Appboy.sharedInstance()?.user.facebookUser = facebookUser
    }
    
}
