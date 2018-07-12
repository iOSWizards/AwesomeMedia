//
//  QuestsGraphQLModel.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/6/17.
//

import Foundation

public struct QuestGraphQLModel {
    
    // MARK: - Model Sections
    
    // Quest
    
    static let questModel = "id name published publishedAt enrollmentStartedAt enrollmentsCount duration courseStartedAt courseEndedAt url settings { \(questSettingsModel) } shareAsset { \(assetImageModel) } coverAsset { \(assetImageModel) } userProgress { \(userProgressModel) } authors { \(authorModel) }"
    static let questCommunityModel = "id name published settings { \(questSettingsModel) }"
    static let questContentModel = "\(questModel) pages { \(pageModel) }"
    static let questSettingsModel = "tribelearnTribeId studentsCount salesUrl shareImageUrl perpetual facebookGroupImageUrl facebookGroupPassPhrase facebookGroupUrl facebookGroupId awcProductId"
    static let userProgressModel = "daysCompleted introsCompleted totalDays totalDaysCompleted totalIntros totalIntrosCompleted started ended startedAt endedAt completed completedAt currentDay { \(pageModel) }"
    
    // My Time
    static let questMyTimeModel = "id name duration courseStartedAt courseEndedAt url settings { \(questSettingsModel) } coverAsset { \(assetImageModel) } userProgress { \(userProgressMyTimeModel) } pages { \(pageMyTimeModel) }"
    static let userProgressMyTimeModel = "daysCompleted introsCompleted started ended completed currentDay { \(pageMyTimeContentModel) }"
    static let pageMyTimeModel = "id name type position duration groupName completed"
    static let pageMyTimeContentModel = "\(pageMyTimeModel) sections { \(sectionMyTimeModel) } "
    static let sectionMyTimeModel = "id duration position type coverAsset { \(assetImageModel) }"
    
    // Author
    static let authorModel = "id name"
    
    // Assets
    static let assetImageModel = "id thumbnailUrl url"
    static let assetModel = "id contentType duration edgeUrl filesize overmindId secure status thumbnailUrl url renditions { \(renditionModel) } markers { \(markerModel) } "//captions  { \(captionsModel) }" // we are not adding captions yet as they are not in production
    
    static let renditionModel = "id contentType duration edgeUrl filesize overmindId secure status thumbnailUrl url"
    
    static let markerModel = "id name status time"
    
    static let captionsModel = "captionAsset { \(captionAssetModel) } default label language"
    static let captionAssetModel = "id default label language url"
    
    // Page
    
    static let pageModel = "id name position description type date completionsCount duration groupName completed"
    static let pageContentModel = "\(pageModel) sections { \(sectionModel) } tasks { \(taskModel) }"
    
    static let taskModel = "completed completionDetails imageUrl id description name position required type coverAsset { \(assetImageModel) }"
    
    static let sectionModel = "id duration position type primaryAsset{ \(assetModel) } coverAsset{ \(assetImageModel) } info{ \(sectionInfoModel) }"
    
    static let sectionInfoModel = "id body downloadable externalLink mode title link caption enrollButtonText testimonialAuthorName testimonialAuthorTitle testimonialType"
    
    // MARK: - Quests Query
    
    private static let questsModel = "query { quests { \(questModel) } }"

    public static func queryQuests() -> [String: AnyObject] {
        return ["query": questsModel as AnyObject]
    }
    
    // MARK: - My Time Query
    
    private static let myTimeModel = "query { quests { \(questMyTimeModel) } }"
    
    public static func queryMyTime() -> [String: AnyObject] {
        return ["query": myTimeModel as AnyObject]
    }
    
    // MARK: - Quest Communities Query // it's the same as quests, but simpler
    
    private static let questCommunitiesModel = "query { quests { \(questCommunityModel) } }"
    
    public static func queryQuestCommunities() -> [String: AnyObject] {
        return ["query": questCommunitiesModel as AnyObject]
    }
    
    // MARK: - Single Quest Query
    
    private static let singleQuestModel = "query { quest(id:%@) { \(questContentModel) } }"
    
    public static func querySingleQuest(withId id: String) -> [String: AnyObject] {
        return ["query": String(format: singleQuestModel, arguments: [id]) as AnyObject]
    }
    
    // MARK: - Single Quest Page Query
    
    private static let singleQuestPageModel = "query { page(id:%@) { \(pageContentModel) } }"
    
    public static func querySingleQuestPage(withId id: String) -> [String: AnyObject] {
        return ["query": String(format: singleQuestPageModel, arguments: [id]) as AnyObject]
    }
    
    // MARK: - Mark Completed Content Mutation
    
    private static let markContentCompleteModel = "mutation { markContentComplete(contentId: %@) { page { id } } }"
    
    public static func mutateMarkContentComplete(withId id: String) -> [String: AnyObject] {
        return ["query": String(format: markContentCompleteModel, arguments: [id]) as AnyObject]
    }
    
    // MARK: - Mark Completed Task Mutation
    
    private static let markTaskCompleteModel = "mutation { markTaskComplete(taskId: %@) { task { id } } }"
    
    public static func mutateMarkTaskComplete(withId id: String) -> [String: AnyObject] {
        return ["query": String(format: markTaskCompleteModel, arguments: [id]) as AnyObject]
    }
    
    // MARK: - Update Completed Task Mutation
    
    private static let updateTaskCompleteModel = "mutation { updateTaskCompletion(details: \"%@\", taskId: %@) { task { id } } }"
    
    public static func mutateUpdateTaskComplete(withId id: String, details: String) -> [String: AnyObject] {
        return ["query": String(format: updateTaskCompleteModel, arguments: [details, id]) as AnyObject]
    }
    
    // MARK: - Enroll User Mutation
    
    private static let enrollUserModel = "mutation { enrollUser(questId: %@) { quest { id } } }"
    
    public static func mutateEnrollUser(withId id: String) -> [String: AnyObject] {
        return ["query": String(format: enrollUserModel, arguments: [id]) as AnyObject]
    }
    
}
