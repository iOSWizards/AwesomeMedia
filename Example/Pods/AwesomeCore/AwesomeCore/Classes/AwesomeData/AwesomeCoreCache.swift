//
//  AwesomeCoreCache.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 4/28/18.
//

import RealmSwift
import Realm

public class AwesomeCoreCache: Object {
    @objc dynamic public var key: String = ""
    @objc dynamic public var value: Data? = nil
    
    // MARK: - Realm
    
    override public static func primaryKey() -> String? {
        return "key"
    }
    
    public init(key: String, value: Data) {
        super.init()
        
        self.key = key
        self.value = value
    }
    
    public required init() {
        super.init()
    }
    
    public required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    public required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    public func save() {
        let realm = try? Realm()
        ((try? realm?.write {
            realm?.create(AwesomeCoreCache.self, value: self, update: true)
        }) as ()??)
    }
    
    public static func object(forKey key: String) -> AwesomeCoreCache? {
        let realm = try? Realm()
        return realm?.object(ofType: AwesomeCoreCache.self, forPrimaryKey: key)
    }
    
    public static func data(forKey key: String) -> Data? {
        return object(forKey: key)?.value
    }
}
