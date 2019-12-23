//
//  MVForceUpdate.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 03/04/2019.
//

import Foundation

public struct FUData: Codable {
    public let data: FUApp?
}

public struct FUApp: Codable {
    public let app: FUSettings?
}

public struct FUSettings: Codable {
    public let settings: FUVersionInfo?
}

public struct FUVersionInfo: Codable {
    public let latestVersion: String?
    public let lastStableVersion: String?
    public let updateMessage: String?
}
