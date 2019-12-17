//
//  MVAnalyticsHelper.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 18/10/18.
//

import Foundation
import AwesomeCore

struct MVAnalyticsHelper {
    
    static let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "not found"
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    
    static func runMVAnalyticsIdentify(appId: AwesomeTrackingAppIdentifier, homeUser: UserProfile?) {
        
        let context = MVAnalyticsIdentifyContext.init(appsflyerDeviceId: AppsflyerHelper.appsFlyerUID, deviceId: AwesomeTrackingConstants.deviceId, appName: appId.rawValue, appVersion: appVersion, os: "iOS", ip: "")
        var traits = MVAnalyticsIdentifyTraits.init(email: "")
        if let email = homeUser?.email {
            traits = MVAnalyticsIdentifyTraits.init(email: email)
        }
        
        guard let uid = homeUser?.uid else {
            return
        }
        
        let identity = MVAnalyticsIdentify.init(userId: uid, context: context, traits: traits)
        MVAnalyticsIdentifyBO.identify(identity, params: .standard) { (_, _) in }
        
    }
    
    static func track(_ eventName: String, with params: AwesomeTrackingDictionary, appId: AwesomeTrackingAppIdentifier, user: UserProfile?, ftuVersion: String) {
        
        var contentVerb = eventName
        if let verb = eventName.components(separatedBy: " ").first {
            contentVerb = verb
        }
        
        var object = MVAnalyticsEventObject.init(objectType: AwesomeTrackingCategory.getCategoryFromEvent(eventName), title: eventName)
        
        for param in params.stringLiteral() {
            switch param.key {
            case AwesomeTrackingParams.assetID.rawValue:
                object.assetId = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.day.rawValue:
                object.day = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.categoryId.rawValue:
                object.categoryId = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.answerId.rawValue:
                object.answerId = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.dayType.rawValue:
                object.type = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.questName.rawValue:
                object.questName = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.questID.rawValue:
                object.questId = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.cohortName.rawValue:
                object.cohortName = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.cohortID.rawValue:
                object.cohortId = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.dayPosition.rawValue:
                object.dayPosition = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.episodeId.rawValue:
                object.episodeId = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.channelId.rawValue:
                object.channelId = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.academyId.rawValue:
                object.academyId = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.screen.rawValue:
                object.screen = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.courseName.rawValue:
                object.courseName = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.courseID.rawValue:
                object.courseId = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.categoryName.rawValue:
                object.categoryName = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.mediaId.rawValue:
                object.mediaId = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.mediaType.rawValue:
                object.mediaType = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.mediaName.rawValue:
                object.mediaName = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.channelName.rawValue:
                object.channelName = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.seriesId.rawValue:
                object.seriesId = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.seriesName.rawValue:
                object.seriesName = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.mediaContentTitle.rawValue:
                object.mediaContentTitle = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.part.rawValue:
                object.part = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.view.rawValue:
                object.view = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.category.rawValue:
                object.category = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.categoryLocation.rawValue:
                object.categoryLocation = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.groupName.rawValue:
                object.communityName = param.value as? String ?? ""
                break
            case AwesomeTrackingParams.groupId.rawValue:
                object.communityId = param.value as? String ?? ""
                break
            default:
                break
            }
        }
        
        let actor = MVAnalyticsEventActor.init(objectType: "user", id: user?.uid ?? "", appVersion: appVersion, os: "iOS", osVersion: UIDevice.current.systemVersion, deviceBrand: "apple", model: UIDevice.current.model, appName: appId.rawValue, deviceId: AwesomeTrackingConstants.deviceId, platform: "iOS", version: ftuVersion, email: user?.email ?? "")
        let content = MVAnalyticsEventContent.init(published: dateFormatter.string(from: Date()), actor: actor, verb: contentVerb, object: object)
        let event = MVAnalyticsEvent.init(event: [content])
        
        MVAnalyticsEventBO.track(event, params: .standard) { (_, _) in }
        
    }
    
}
