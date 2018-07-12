//
//  AwesomeCoreStorage.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 20/09/17.
//

import Foundation

struct AwesomeCoreStorage {
    
    static var lastCourseId: Int {
        get {
            return UserDefaults.standard.integer(forKey: "AwesomeCoreLastCourseId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AwesomeCoreLastCourseId")
        }
    }
    
    static var isMembership: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "AwesomeCoreUserMeIsMembership")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "AwesomeCoreUserMeIsMembership")
        }
    }
    
}
