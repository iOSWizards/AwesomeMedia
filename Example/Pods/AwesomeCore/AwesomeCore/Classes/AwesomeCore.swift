//
//  AwesomeCore.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 05/07/17.
//

import Foundation
import Realm
import RealmSwift

public class AwesomeCore: NSObject {
    
    public static var shared = AwesomeCore()
    
    public static var timeoutTime: TimeInterval = 30

    var userProfileBO: UserProfileBOProtocol = UserProfileBO()
    
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
    
    public var bearerToken: String = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6Imxlb25hcmRvQG1pbmR2YWxsZXkuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImlzcyI6Imh0dHBzOi8vbWluZHZhbGxleS5hdXRoMC5jb20vIiwic3ViIjoiYXV0aDB8NTg3Y2M4ZjNhY2JiYTQ2NDZhOWM4YTYyIiwiYXVkIjoid0RlNFRaVWNSU1A5dnZWMlR0cDRnSHVUYk9ESE9rdDciLCJpYXQiOjE1MDc3MDIzMTMsImV4cCI6MTUwODkxMTkxM30.tWy6xJMfMBWMxIlPBew9S534Tkovk1VmYuxRj-RRFqs" {
        didSet {
            userProfileBO.syncUserProfile(forcingUpdate: true)
            UserMeBO.fetchUserMe { (_, _) in
            }
        }
    }
    
    private override init() {
        super.init()
    }
    
    public static func clearCache() {
        AwesomeCoreCacheManager.clearCache()
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
    
    // MARK: Mobile Request Header
    static func getMobileRequestHeaderWithApiKeys() -> [String: String] {
        let headers = AwesomeCore.shared.isOICD ? [ "Authorization": AwesomeCore.shared.bearerToken,
                                                    "x-mv-auth0": "mobile", "api_id": ACConstants.shared.api_id,
                                                    "api_key": ACConstants.shared.api_key,
                                                    "Timezone": TimeZone.current.identifier] : [ "Authorization": AwesomeCore.shared.bearerToken,
                                                                                                 "api_id": ACConstants.shared.api_id,
                                                                                                 "api_key": ACConstants.shared.api_key,
                                                                                                 "Timezone": TimeZone.current.identifier]
        
        return headers
    }
    
}

