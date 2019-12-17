//
//  TodayCard.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/02/19.
//

import Foundation

public struct TodayCard: Codable {
    
    public let deepLink: String?
    public let description: String?
    public let id: String?
    public let position: Int?
    public let quest: Quest?
    public let contentAsset: QuestAsset?
    public let media: QuestMedia?
    public let settings: TodayCardSettings?
    public let smallCoverAsset: QuestAsset?
    public let largeCoverAsset: QuestAsset?
    public let subtitle: String?
    public let title: String?
    public let type: String?
    
    public init(title: String?) {
        self.title = title
        self.description = nil
        self.id = nil
        self.position = nil
        self.quest = nil
        self.contentAsset = nil
        self.media = nil
        self.settings = nil
        self.smallCoverAsset = nil
        self.largeCoverAsset = nil
        self.subtitle = nil
        self.type = nil
        self.deepLink = nil
    }
    
}

// MARK: - Coding keys

extension TodayCard {
    
    private enum CodingKeys: String, CodingKey {
        case deepLink
        case description
        case id
        case position
        case quest
        case contentAsset = "content_asset"
        case media
        case settings
        case smallCoverAsset = "small_cover_asset"
        case largeCoverAsset = "large_cover_asset"
        case subtitle
        case title
        case type
    }
    
}

public struct TodayCardSettings: Codable {
    public let themeColor: String?
    public let startDate: String?
    public let icon: String?
}

// MARK: - Coding keys

extension TodayCardSettings {
    
    private enum CodingKeys: String, CodingKey {
        case themeColor = "theme_color"
        case startDate = "start_date"
        case icon
    }
    
}
