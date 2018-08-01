//
//  QuestFetch.swift
//  AwesomeCore
//
//  Created by Antonio on 1/26/18.
//

import Foundation

public enum Param {
    case QuestId
    case QuestPageId
}

public struct QuestFetch: Equatable {
    
    public let forcingUpdate: Bool
    public let loadFromDB: Bool
    public let updateDB: Bool
    public let params: [Param: String]?
    
    public init(forcingUpdate: Bool, loadFromDB: Bool, updateDB: Bool, params: [Param: String]? = nil) {
        self.forcingUpdate = forcingUpdate
        self.loadFromDB = loadFromDB
        self.updateDB = updateDB
        self.params = params
    }
    
    public init(_ params: [Param: String]? = nil) {
        self.init(forcingUpdate: false, loadFromDB: false, updateDB: false, params: params)
    }
    
    public init(forcingUpdate: Bool, loadFromDB: Bool) {
        self.init(forcingUpdate: forcingUpdate, loadFromDB: loadFromDB, updateDB: !loadFromDB)
    }
    
}

// MARK: - Equatable

extension QuestFetch {
    
    static func paramsMatch(_ paramLhs: [Param: String]?, _ paramRhs: [Param: String]?) -> Bool {
        if paramLhs == nil && paramRhs == nil {
            return true
        } else if paramLhs != nil && paramRhs != nil {
            return paramLhs! == paramRhs!
        } else {
            return false
        }
    }
    
    public static func ==(lhs: QuestFetch, rhs: QuestFetch) -> Bool {
        if lhs.forcingUpdate != rhs.forcingUpdate {
            return false
        }
        if lhs.loadFromDB != rhs.loadFromDB {
            return false
        }
        if lhs.updateDB != rhs.updateDB {
            return false
        }
        if !paramsMatch(lhs.params, rhs.params) {
            return false
        }
        return true
    }
}
