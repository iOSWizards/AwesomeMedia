//
//  Quest.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/09/17.
//

import Foundation

enum QuestContentType: String {
    case warmup = "intro"
    case day = "day"
}

public class Quest: Codable, Equatable {
    
    public let authors: [QuestAuthor]?
    public let categories: [QuestCategory]?
    public let courseEndedAt: String?
    public let courseStartedAt: String?
    public let coverAsset: QuestAsset?
    public let shareAsset: QuestAsset?
    public let duration: Double?
    public let enrollmentStartedAt: String?
    public let enrollmentsCount: Int?
    public let id: String?
    public let name: String?
    public let url: String?
    public var pages: [QuestPage]?
    public let published: Bool?
    public let publishedAt: String?
    public let settings: QuestSettings?
    public var userProgress: QuestUserProgress?
    
    init(authors: [QuestAuthor]?,
         categories: [QuestCategory]?,
         courseEndedAt: String?,
         courseStartedAt: String?,
         coverAsset: QuestAsset?,
         shareAsset: QuestAsset?,
         duration: Double?,
         enrollmentStartedAt: String?,
         enrollmentsCount: Int?,
         id: String?,
         name: String?,
         pages: [QuestPage]?,
         published: Bool?,
         publishedAt: String?,
         url: String?,
         settings: QuestSettings?,
         userProgress: QuestUserProgress?) {
        self.authors = authors
        self.categories = categories
        self.courseEndedAt = courseEndedAt
        self.courseStartedAt = courseStartedAt
        self.coverAsset = coverAsset
        self.shareAsset = shareAsset
        self.duration = duration
        self.enrollmentStartedAt = enrollmentStartedAt
        self.enrollmentsCount = enrollmentsCount
        self.id = id
        self.name = name
        self.pages = pages
        self.published = published
        self.publishedAt = publishedAt
        self.url = url
        self.settings = settings
        self.userProgress = userProgress
    }
    
    // MARK: - Computed properties
    
    public var didStart: Bool {
        return userProgress?.started ?? false
    }
    
    public var didFinish: Bool {
        return userProgress?.ended ?? false
    }
    
    public var isFMQ: Bool {
        return settings?.perpetual ?? false
    }
    
    public var progressTitleLibrary: String? {
        return "\(userProgress?.currentDay?.type ?? "Day".localized) \(userProgress?.currentDay?.position ?? 1) \("of".localized) \(userProgress?.totalDays ?? 0)"
    }
    
    public var progressTitleTOC: String? {
        return "\(userProgress?.totalDaysCompleted ?? 0) \("of".localized) \(userProgress?.totalDays ?? 0) \("Completed".localized.lowercased())"
    }
    
    public var startDate: String {
        return formatDate(courseStartedAt, withLabel: "Begins")
    }
    
    public var endDate: String {
        return formatDate(courseEndedAt, withLabel: "Ended")
    }
    
    public var beginsInString: String {
        guard let dateParsed = extractDate(date: courseStartedAt) else {
            return ""
        }
        return "\("Quest begins in".localized) \(dateParsed.days(from: Date())) \("days".localized)"
    }
    
    public var currentDayPosition: String {
        return userProgress?.currentDay?.dayPosition ?? ""
    }
    
    public var progress : Float {
        let daysCompleted = Float(userProgress?.totalDaysCompleted ?? 0)
        let totalDays = Float(userProgress?.totalDays ?? 0)
        let result = Float(daysCompleted/totalDays)
        if result.isInfinite || result.isNaN {
            return 0
        }
        return abs(result.roundTo(places: 3))
    }
    
    public var pagesDuration: Double {
        guard let pages = pages else {
            return 0
        }
        return pages.map({$0.duration ?? 0}).reduce(0, +)
    }
    
    public var durationString: String {
        if pagesDuration == 0 {
            return ""
        }
        return pagesDuration.timeString
    }
    
    public var authorNames: String {
        guard let authors = authors else {
            return ""
        }
        var authorNames = ""
        for author in authors {
            if let name = author.name {
                if !authorNames.isEmpty {
                    authorNames = authorNames.appending(", ")
                }
                authorNames = authorNames.appending(name)
            }
        }
        return authorNames
    }
    
    public var dayContents: [QuestPage] {
        return contents(withType: QuestContentType.day)
    }
    
    public var warmupContents: [QuestPage] {
        return contents(withType: QuestContentType.warmup)
    }
    
    public var hasCommunity: Bool {
        return settings?.facebookGroupUrl?.count ?? 0 != 0 && settings?.facebookGroupUrl != nil
    }
    
    // MARK: - Helpers
    
    /// Formats the given String date using the mask **dd MMM yyyy**
    ///
    /// - Parameters:
    ///   - date: date as **yyyy-MM-dd'T'HH:mm:ssZ** to format
    ///   - withLabel: a label to be placed right in front of the date formatted.
    /// - Returns: a string containing the date formatted plus the label or an empty string in case it fails to parse.
    private func formatDate(_ date: String?, withLabel: String) -> String {
        guard let dateParsed = extractDate(date: date) else {
            return ""
        }
        let dateFormated = ParserCoreHelper.dateFormatter_dd_MMM_yyyy.string(from: dateParsed)
        return "\(withLabel.trimmed.localized) \(dateFormated)"
    }
    
    private func extractDate(date: String?) -> Date? {
        guard let rawDateString = date, !rawDateString.isEmpty else {
            return nil
        }
        guard let dateParsed = ParserCoreHelper.dateFormatter.date(from: rawDateString) else {
            return nil
        }
        return dateParsed
    }
    
    private func contents(withType type: QuestContentType) -> [QuestPage] {
        guard let pages = pages else {
            return []
        }
        
        return pages.filter { (page) -> Bool in
            return page.type == type.rawValue
            }.sorted { (page1, page2) -> Bool in
                return page1.position < page2.position
        }
    }
    
}

// MARK: - JSON Key

public struct QuestsDataKey: Codable {
    
    public let data: QuestsKey
    
}

public struct QuestsKey: Codable {
    
    public let quests: [Quest]
    
}

public struct SingleQuestDataKey: Codable {
    
    public let data: SingleQuestKey
    
}

public struct SingleQuestKey: Codable {
    
    public let quest: Quest
    
}

// MARK: - Equatable

extension Quest {
    
    public static func ==(lhs: Quest, rhs: Quest) -> Bool {
        if !Utility.equals(lhs.authors, rhs.authors) {
            return false
        }
        if !Utility.equals(lhs.categories, rhs.categories) {
            return false
        }
        if lhs.courseEndedAt != rhs.courseEndedAt {
            return false
        }
        if lhs.courseStartedAt != rhs.courseStartedAt {
            return false
        }
        if lhs.coverAsset != rhs.coverAsset {
            return false
        }
        if lhs.shareAsset != rhs.shareAsset {
            return false
        }
        if lhs.duration != rhs.duration {
            return false
        }
        if lhs.enrollmentStartedAt != rhs.enrollmentStartedAt {
            return false
        }
        if lhs.enrollmentsCount != rhs.enrollmentsCount {
            return false
        }
        if lhs.id != rhs.id {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if !Utility.equals(lhs.pages, rhs.pages) {
            return false
        }
        if lhs.published != rhs.published {
            return false
        }
        if lhs.publishedAt != rhs.publishedAt {
            return false
        }
        if lhs.url != rhs.url {
            return false
        }
        if lhs.settings != rhs.settings {
            return false
        }
        if lhs.userProgress != rhs.userProgress {
            return false
        }
        return true
    }
}

