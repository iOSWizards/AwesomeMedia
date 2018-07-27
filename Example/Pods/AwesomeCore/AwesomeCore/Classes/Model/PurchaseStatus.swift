//
//  PurchaseStatus.swift
//  AwesomeCore-iOS10.0
//
//  Created by Emmanuel on 16/07/2018.
//

import Foundation

public struct PurchaseStatus: Codable {
    public let hasAccess: Bool?
}

extension PurchaseStatus {
    public enum CodingKeys: String, CodingKey {
        case hasAccess
    }
}
