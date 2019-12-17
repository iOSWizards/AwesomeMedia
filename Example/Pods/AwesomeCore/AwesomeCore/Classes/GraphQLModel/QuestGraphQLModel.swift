//
//  QuestsGraphQLModel.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/6/17.
//

import Foundation

public enum QuestProgress: String {
    case ongoing = "ongoing"
    case completed = "completed"
    case available = "available"
}

public struct QuestGraphQLModel {
    
    // MARK: - Model Sections
    
    // Quest
    
    static let questDefaultModel = "id name type courseStartedAt courseEndedAt releases { enrollmentsCount } groups { unlockAfterDays } settings { \(questSettingsModel) } coverAsset { \(assetImageModel) } authors { id name description portraitAsset { \(assetImageModel) } } nextRelease { id courseEndedAt courseStartedAt enrollmentsCount } daysCount lessonsCount description trailerAsset { \(assetModel) } trailerCoverAsset { \(assetImageModel) }"
    static let questModel = "\( questDefaultModel ) userProgress { \(userProgressModel) }"
    static let questSpotlightModel = "id name authors { \(authorModel) } pages { \(pageSpotlightModel) }"
    static let questCommunityModel = "id name published settings { \(questSettingsModel) }"
    static let questContentModel = "\(questDefaultModel) userProgress { \(userProgressQuestContentModel) } url published publishedAt enrollmentStartedAt enrollmentsCount duration pages { \(pageModel) } materials { \(sectionModel) } groups { \(groupModel) } authors { \(authorModel) } shareAsset { \(assetImageModel) } "
    static let questSettingsModel = "studentsCount salesUrl shareImageUrl perpetual facebookGroupImageUrl facebookGroupPassPhrase facebookGroupUrl facebookGroupId awcProductId newUi enableReleaseChange"
    static let userProgressModel = "currentPage { \(pageModel) } daysCompleted ended completed started totalDays totalDaysCompleted totalDaysMissed totalLessons totalLessonsCompleted totalLessonsMissed release { id }"
    static let userProgressQuestContentModel = "currentPage { \(pageModel) } currentGroup { \(groupModel) } currentLesson { \(pageModel) }  nextPage { id name type position locked } daysCompleted introsCompleted lessonsCompleted ended endedAt completed completedAt enrolledAt enrollmentStartedAt started startedAt totalDays totalDaysCompleted totalDaysMissed totalLessons totalLessonsCompleted totalLessonsMissed totalIntros totalIntrosCompleted"
    static let releaseModel = "id courseStartedAt courseEndedAt enrollmentsCount"
    static let questIntakeUserProgressModel = "release { \(releaseModel) }"
    static let questIntakeModel = "releases(status: \"%@\", limit: %@) { \(releaseModel) } userProgress { \(questIntakeUserProgressModel)}"
    static let groupModel = "id description name locked position unlockAfterDays secondsTillUnlock"
    
    // My Time
    static let questMyTimeModel = "id name duration courseStartedAt courseEndedAt url settings { \(questSettingsModel) } coverAsset { \(assetImageModel) } userProgress { \(userProgressMyTimeModel) } pages { \(pageMyTimeModel) }"
    static let userProgressMyTimeModel = "daysCompleted introsCompleted started ended completed totalDaysMissed totalDays totalDaysCompleted totalLessons totalLessonsCompleted currentPage { \(pageMyTimeContentModel) }"
    static let pageMyTimeModel = "id name type position duration groupName completed coverAsset { \(assetImageModel) }"
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
    
    static let pageModel = "id name position type date completionsCount duration groupName completed coverAsset { \(assetImageModel) } groupLocked locked missed"
    static let pageSpotlightModel = "id name position type"
    static let pageContentModel = "\(pageModel) description groupDescription sections { \(sectionModel) } tasks { \(taskModel) } shareAsset { \(assetImageModel) } nextPage { id name type position locked }"
    
    static let taskModel = "completed completionDetails imageUrl id description name position required type coverAsset { \(assetImageModel) }"
    
    static let sectionModel = "id duration position type primaryAsset{ \(assetModel) } coverAsset{ \(assetImageModel) } info{ \(sectionInfoModel) }"
    
    static let sectionInfoModel = "id body downloadable externalLink mode title link caption enrollButtonText testimonialAuthorName testimonialAuthorTitle testimonialType"
    
    // MARK: - Quests Query
    
    private static let questsModel = "query { quests { \(questModel) } }"
    
    public static func queryQuests() -> [String: AnyObject] {
        return ["query": questsModel as AnyObject]
    }
    
    // MARK: - Quests by State Query
    
    private static let questsStateModel = "query { quests(progress:\"%@\") { \(questModel) } }"
    
    public static func queryQuests(withProgress progress: QuestProgress) -> [String: AnyObject] {
        return ["query": String(format: questsStateModel, arguments: [progress.rawValue]) as AnyObject]
    }
    
    // MARK: - Quests Spotlight Query
    
    private static let questsSpotlightModel = "query { quests { \(questSpotlightModel) } }"
    
    public static func querySpotlightQuests() -> [String: AnyObject] {
        return ["query": questsSpotlightModel as AnyObject]
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
    
    // MARK: - Single Quest Intake Query
    
    private static let singleQuestIntakeModel = "query { quest(id:%@) { \(questIntakeModel) } }"
    
    public static func querySingleQuestIntake(withId id: String, releaseStatus: String, releaseLimit: String) -> [String: AnyObject] {
        return ["query": String(format: singleQuestIntakeModel, arguments: [id, releaseStatus, releaseLimit]) as AnyObject]
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
    
    // MARK: - Enroll Release User Mutation
    
    private static let enrollUserReleaseModel = "mutation { enrollUser(questId: %@, releaseId: %@) { quest { id } } }"
    
    public static func mutateEnrollUserRelease(withId id: String, releaseId: String) -> [String: AnyObject] {
        return ["query": String(format: enrollUserReleaseModel, arguments: [id, releaseId]) as AnyObject]
    }
    
}
