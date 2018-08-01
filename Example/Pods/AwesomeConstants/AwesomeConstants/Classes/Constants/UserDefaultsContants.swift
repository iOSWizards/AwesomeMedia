//
//  UserDefaultsContants.swift
//  Mindvalley
//
//  Created by Evandro Harrison Hoffmann on 2/14/18.
//  Copyright © 2018 Mindvalley. All rights reserved.
//

import Foundation

public var isAdmin: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "isAdmin")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "isAdmin")
    }
}

public var isElegibleForAdmin: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "isElegibleForAdmin")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "isElegibleForAdmin")
    }
}

public var didEnablePushNotifications: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "didEnablePushNotifications")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "didEnablePushNotifications")
    }
}

public var didPresentEnablePushNotifications: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "didPresentEnablePushNotifications")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "didPresentEnablePushNotifications")
    }
}

public var dateForEnablePushNotifications: String {
    get {
        return UserDefaults.standard.string(forKey: "dateForEnablePushNotifications") ?? ""
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "dateForEnablePushNotifications")
    }
}

public var dateForSubscriptionPurchased: Date? {
    get {
        return UserDefaults.standard.string(forKey: "dateForSubscriptionPurchased")?.toDate(format: "dd/MM/yyyy HH:mm")
    }
    set {
        UserDefaults.standard.set(newValue?.toString(format: "dd/MM/yyyy HH:mm"), forKey: "dateForSubscriptionPurchased")
    }
}

public var isMediaWifiOnly: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "isMediaWifiOnly")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "isMediaWifiOnly")
    }
}

public var didShowRatingRequestChapter: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "didShowRatingRequestChapter")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "didShowRatingRequestChapter")
    }
}

public var didShowRatingRequestCourse: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "didShowRatingRequestCourse")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "didShowRatingRequestCourse")
    }
}

public var numberOfTimesCompletedChapter: Int {
    get {
        return UserDefaults.standard.integer(forKey: "numberOfTimesCompletedChapter")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "numberOfTimesCompletedChapter")
    }
}

public var numberOfTimesCompletedCourse: Int {
    get {
        return UserDefaults.standard.integer(forKey: "numberOfTimesCompletedCourse")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "numberOfTimesCompletedCourse")
    }
}

public var didShowRatingRequest: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "didShowRatingRequest")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "didShowRatingRequest")
    }
}

public var didShowTasksTutorial: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "didShowTasksTutorial")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "didShowTasksTutorial")
    }
}

public var numberOfTimesCompletedDay: Int {
    get {
        return UserDefaults.standard.integer(forKey: "numberOfTimesCompletedDay")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "numberOfTimesCompletedDay")
    }
}

public var didEnableSiri: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "didEnableSiri")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "didEnableSiri")
    }
}

public var didEnableHealthKit: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "didEnableHealthKit")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "didEnableHealthKit")
    }
}

public var didOnboarding: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "didOnboarding")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "didOnboarding")
    }
}

public var didPassOIDCFlow: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "didPassOIDCFlow")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "didPassOIDCFlow")
    }
}
