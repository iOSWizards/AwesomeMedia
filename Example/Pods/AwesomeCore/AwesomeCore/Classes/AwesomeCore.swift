//
//  AwesomeCore.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 05/07/17.
//

import Foundation
import Realm
import RealmSwift

public enum AwesomeCoreApp {
    case mindvalley
    case soulvana
}

public class AwesomeCore: NSObject {
    
    public static var shared = AwesomeCore()
    
    public static var timeoutTime: TimeInterval = 30
    
    let defaultQueue = DispatchQueue.global(qos: .default)
    let dispatchSemaphore = DispatchSemaphore(value: 0)

    var userProfileBO: UserProfileBOProtocol = UserProfileBO()
    public var bearerTokenCallback: () -> String = { return "" }
    public var apiKey: String = ""
    public var apiId: String = ""
    
    public var isOICD = true {
        didSet {
            NSLog("AwesomeCore OICD: \(isOICD ? "true": "false")")
        }
    }
    
    public var prodEnvironment = true {
        didSet {
            NSLog("AwesomeCore environment: \(prodEnvironment ? "PRODUCTION": "DEVELOPMENT")")
        }
    }
    
    var bearerToken: String {
        get {
            return bearerTokenCallback()
        }
    }
    
    public var isTokenRefreshed = false
    
    public var app: AwesomeCoreApp = .soulvana
    
    private override init() {
        super.init()
    }
    
    public static func clearCache() {
        AwesomeCoreCacheManager.clearCache()
    }
    
    // MARK: - Start AwesomeCore after login
    
    public static func start() {
        AwesomeCore.releaseSemaphore()
        AwesomeCore.shared.userProfileBO.syncUserProfile(forcingUpdate: true)
        UserMeBO.fetchUserMe { (_, _) in }
    }
    
    // MARK: - Realm configuration and migration
    
    public static func configureRealmDatabase() {
        let config = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                print("migration succeeded")
        })
        Realm.Configuration.defaultConfiguration = config
        print("Realm database location: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
    }
    
    public static func clearDatabase() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    public static func clearUserDefaults() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    public static func releaseSemaphore() {
        AwesomeCore.shared.dispatchSemaphore.signal()
    }
    
    public static func executeBlock(_ block: @escaping () -> Swift.Void) {
        if AwesomeCore.shared.isTokenRefreshed {
            AwesomeCore.shared.defaultQueue.async(execute: block)
        } else {
            AwesomeCore.shared.defaultQueue.async {
                _ = AwesomeCore.shared.dispatchSemaphore.wait(timeout: .now() + 5)
                AwesomeCore.shared.defaultQueue.async(execute: block)
                AwesomeCore.shared.dispatchSemaphore.signal()
            }
        }
    }
    
    // MARK: Mobile Request Header
    static func getMobileRequestHeaderWithApiKeys() -> [String: String] {
        let headers = AwesomeCore.shared.isOICD ? [ "Authorization": AwesomeCore.shared.bearerToken,
                                                    "x-mv-auth0": "mobile", "api_id": AwesomeCore.shared.apiId,
                                                    "api_key": AwesomeCore.shared.apiKey,
                                                    "Timezone": TimeZone.current.identifier] : [ "Authorization": AwesomeCore.shared.bearerToken,
                                                                                                 "api_id": AwesomeCore.shared.apiId,
                                                                                                 "api_key": AwesomeCore.shared.apiKey,
                                                                                                 "Timezone": TimeZone.current.identifier]
        
        return headers
    }
    
    // MARK: - Test Token
    public var testToken: String {
        
        return "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik5FWXpNVVJDT0VFM09FTXlNelpCTkRRNU1EYzBNakU0TlRjek0wRTBNVGd4TmpaR1JUZzVPUSJ9.eyJodHRwczovL2hvbWUubWluZHZhbGxleS5jb20vbG9naW5Qcm92aWRlciI6ImF1dGgwIiwibmlja25hbWUiOiJsZW9uYXJkbyIsIm5hbWUiOiJsZW9uYXJkb0BtaW5kdmFsbGV5LmNvbSIsInBpY3R1cmUiOiJodHRwczovL3MuZ3JhdmF0YXIuY29tL2F2YXRhci8xNjJmMmM2N2E0Nzg4ZjJjNGE0OTJjMzU3MzFiMmVjMj9zPTQ4MCZyPXBnJmQ9aHR0cHMlM0ElMkYlMkZjZG4uYXV0aDAuY29tJTJGYXZhdGFycyUyRmxlLnBuZyIsInVwZGF0ZWRfYXQiOiIyMDE4LTA4LTA4VDEzOjM0OjAxLjU3N1oiLCJlbWFpbCI6Imxlb25hcmRvQG1pbmR2YWxsZXkuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImlzcyI6Imh0dHBzOi8vbWluZHZhbGxleS5hdXRoMC5jb20vIiwic3ViIjoiYXV0aDB8NTg3Y2M4ZjNhY2JiYTQ2NDZhOWM4YTYyIiwiYXVkIjoia3Btb2F1M2tTUkhueDhHS3BIY2pSUjBldXpiNGxtNnUiLCJpYXQiOjE1MzM3Mzg1MzgsImV4cCI6MTUzNDk0ODEzOH0.VsBH5t2kJyUy22R9PphYNz7sIUSNOl3XJGGMU63Ux2aAKkfJExMyirtrUrc6dwD_--Kppj-d8CyDby9CEuqU5d9PO9hFtMef7ymOMV7Ayn7MKaS61zVKMDfiHr6IqL9YnJjiDUE_VzakTV1iwbnQK5AhhcHYSr9PvQ7AhqLBuX7-PB_Jw4VsZdwz91pbF-vDGK6TkQzYlYyejk6oLn_cHBDvRa6c8Sr1rfC5CbMZ8yxNfPwrFGLUPE_P0_66shBMJwD7Lv-ESUQnAMrJoGYKvNV_MuKtKhlozYfKiogkNPbJMqX-q3ihpq5GK3Tw19mhILT1AIsayFVsZvoLfWAsDA"
    }
    
}

