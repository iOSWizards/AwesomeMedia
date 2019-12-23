//
//  Community.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 30/01/18.
//

import Foundation

public struct CommunityData: Codable {
    public let communities: Communities
}

public struct CommunityRootData: Codable {
    public let data: CommunityListData
}

public struct CommunityListData: Codable {
    public let communities: [Community]
}

public struct Communities: Codable {
    public let publicGroups: [Community]
    public let tribeMembership: [Community]
    public let privateGroups: [Community]
}

public struct Community: Codable {
    public let url: String?
    public let type: String?
    public let productIds: [String]?
    public var passphrase: String?
    public let name: String?
    public let id: String?
    public let groupId: String?
    public let description: String?
    public let backgroundAsset: QuestAsset?
}

// MARK: - Coding keys

//extension Communities {
//    private enum CodingKeys: String, CodingKey {
//        case publicGroups = "public_pages"
//        case tribeMembership = "tribe_memberships"
//        case privateGroups = "private_groups"
//    }
//}
//
//extension Community {
//    private enum CodingKeys: String, CodingKey {
//        case id
//        case productId = "awc_product_id"
//        case groupId = "group_id"
//        case imageUrl = "image_url"
//        case name
//        case passphrase
//        case type = "group_type"
//        case url
//    }
//}

// MARK: - Equatable

extension Communities {
    public static func ==(lhs: Communities, rhs: Communities) -> Bool {
        if lhs.publicGroups.first?.groupId != rhs.publicGroups.first?.groupId  {
            return false
        }
        return true
    }
}


// MARK: - Community Swift

//import Foundation
//import RealmSwift
//import Realm
//
//public struct CommunityData: Decodable {
//
//    public let communities: Communities
//}
//
//public class Communities: Object, Decodable {
//
//    @objc dynamic var id = 0
//    public var publicGroups = List<Community>()
//    public var tribeMembership = List<Community>()
//    public var privateGroups = List<Community>()
//
//    // MARK: - Realm
//
//    override public static func primaryKey() -> String? {
//        return "id"
//    }
//
//    public convenience init(publicGroups: [Community], tribeMembership: [Community], privateGroups: [Community]) {
//        self.init()
//
//        self.privateGroups.append(objectsIn: privateGroups)
//        self.publicGroups.append(objectsIn: publicGroups)
//        self.tribeMembership.append(objectsIn: tribeMembership)
//    }
//
//    public convenience required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let privateGroups = try container.decode([Community].self, forKey: .privateGroups)
//        let publicGroups = try container.decode([Community].self, forKey: .publicGroups)
//        let tribeMembership = try container.decode([Community].self, forKey: .tribeMembership)
//
//        self.init(publicGroups: publicGroups, tribeMembership: tribeMembership, privateGroups: privateGroups)
//    }
//
//    public required init() {
//        super.init()
//    }
//
//    public required init(value: Any, schema: RLMSchema) {
//        super.init(value: value, schema: schema)
//    }
//
//    public required init(realm: RLMRealm, schema: RLMObjectSchema) {
//        super.init(realm: realm, schema: schema)
//    }
//
//}
//
//public class Community: Object, Codable {
//
//    @objc dynamic public var id: Int = 0
//    @objc dynamic public var productId: String = ""
//    @objc dynamic public var groupId: String = ""
//    @objc dynamic public var imageUrl: String = ""
//    @objc dynamic public var name: String = ""
//    @objc dynamic public var passphrase: String = ""
//    @objc dynamic public var type: String = ""
//    @objc dynamic public var url: String = ""
//
//    public convenience init(id: Int, productId: String, groupId: String, imageUrl: String, name: String, passphrase: String, type: String, url: String) {
//        self.init()
//
//        self.id = id
//        self.productId = productId
//        self.groupId = groupId
//        self.imageUrl = imageUrl
//        self.name = name
//        self.passphrase = passphrase
//        self.type = type
//        self.url = url
//    }
//
//    public convenience required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let id = try container.decode(Int.self, forKey: .id)
//        let productId = try container.decode(String.self, forKey: .productId)
//        let groupId = try container.decode(String.self, forKey: .groupId)
//        let imageUrl = try container.decode(String.self, forKey: .imageUrl)
//        let name = try container.decode(String.self, forKey: .name)
//        let passphrase = try container.decode(String.self, forKey: .passphrase)
//        let type = try container.decode(String.self, forKey: .type)
//        let url = try container.decode(String.self, forKey: .url)
//
//        self.init(id: id, productId: productId, groupId: groupId, imageUrl: imageUrl, name: name, passphrase: passphrase, type: type, url: url)
//    }
//
//    // MARK: - Realm
//
//    override public static func primaryKey() -> String? {
//        return "url"
//    }
//
//    public required init() {
//        super.init()
//    }
//
//    public required init(value: Any, schema: RLMSchema) {
//        super.init(value: value, schema: schema)
//    }
//
//    public required init(realm: RLMRealm, schema: RLMObjectSchema) {
//        super.init(realm: realm, schema: schema)
//    }
//
//}
//
//// MARK: - Realm
//extension CommunityData {
//    public func save() {
//        let realm = try! Realm()
//
//        try! realm.write {
//            realm.create(Communities.self, value: communities, update: true)
//        }
//    }
//}
//
//extension Community {
//    public static func list() -> Results<Community> {
//        let realm = try! Realm()
//        return realm.objects(Community.self)
//    }
//}
//
//extension Communities {
//    public static func list() -> Results<Communities> {
//        let realm = try! Realm()
//        return realm.objects(Communities.self)
//    }
//}
//
//extension Communities {
//    private enum CodingKeys: String, CodingKey {
//        case publicGroups = "public_pages"
//        case tribeMembership = "tribe_memberships"
//        case privateGroups = "private_groups"
//    }
//}
//
//extension Community {
//    private enum CodingKeys: String, CodingKey {
//        case id
//        case productId = "awc_product_id"
//        case groupId = "group_id"
//        case imageUrl = "image_url"
//        case name
//        case passphrase
//        case type = "group_type"
//        case url
//    }
//}
//
//// MARK: - Equatable
//extension Communities {
//    public static func ==(lhs: Communities, rhs: Communities) -> Bool {
//        if lhs.publicGroups.first?.groupId != rhs.publicGroups.first?.groupId  {
//            return false
//        }
//        return true
//    }
//}
