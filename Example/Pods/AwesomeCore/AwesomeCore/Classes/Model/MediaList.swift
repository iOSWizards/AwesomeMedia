//
//  MediaList.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 31/05/2019.
//

import Foundation

// MARK: - JSON Key

public struct MediaListDataKey: Codable {
    public let data: MediaListKey
}

public struct MediaListKey: Codable {
    public let mediaList: [QuestMedia]
}
