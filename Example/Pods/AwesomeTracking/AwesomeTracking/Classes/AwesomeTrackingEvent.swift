//
//  AwesomeTrackingEvent.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/06/18.
//

import Foundation

public enum AwesomeTrackingEvent: String {
    
    // MARK: - Mindvalley app
    
    case applicationOpened          = "application opened"
    case applicationClosed          = "application closed"
    case applicationInstalled       = "app_installs"
    
    case onboardingStarted          = "onboarding started"
    case onboardingCompleted        = "onboarding completed"
    case quizStarted                = "mtm_quiz_started"
    case quizChosenTopics           = "mtm_quiz_chosen_topics"
    case quizCompleted              = "mtm_quiz_completed"
    
    case userLogin                  = "user login"
    case userSignup                 = "user signup"
    case userLogout                 = "user logout"
    
    case pushNotificationEnabled    = "push notification enabled"
    case pushNotificationTapped     = "push notification tapped"
    
    case courseOpened               = "course (episode) opened"
    case courseCompleted            = "course completed"
    
    case assetPlayed                = "asset played"
    case assetCompleted             = "asset completed"
    case timeMarker                 = "time marker"
    case assetDownloaded            = "file downloaded"
    
    case chapterStarted             = "chapter started"
    case chapterCompleted           = "chapter completed"
    case courseShared               = "course shared"
    
    case tribePostCreated           = "tribe post created"
    case tribePostLiked             = "tribe post liked"
    case tribePostCommented         = "tribe post commented"
    
    case productClicked             = "Product Clicked"
    case checkoutStarted            = "checkout started"
    case checkoutCompleted          = "checkout completed"
    case courseEnrolled             = "course enrolled"
    case salesPageViewed            = "sales page viewed"
    
    case appStoreVisited            = "app store visited"
    case appRated                   = "app rated"
    
    case membershipTabClicked       = "membership tab clicked"
    
    // MARK: - Quests app
    
    case onboardingPageViewed       = "onboarding page viewed"
    case onboardingFMQSelected      = "onboarding fmq selected"
    case onboardingFMQSkipped       = "onboarding fmq skipped"
    
    case questEnrolled              = "quest enrolled"
    case questStarted               = "quest started"
    case fmqStarted                 = "fmq started"
    case questCompleted             = "quest completed"
    
    case dayStarted                 = "day started"
    case dayCompleted               = "day completed"
    case dayShared                  = "day shared"
    
    case tribeVisited               = "tribe visited"
    
    case storePageClose             = "sales page closed"
    case productPurchased           = "product purchased"
    
    case discoverTabViewed          = "discover tab viewed"
    case tribesTabViewed            = "tribes tab viewed"
    case myQuestsTabViewed          = "my quests tab viewed"
    
    case waitListJoined             = "waiting list joined"
    
    case communityTabViewed         = "community tab viewed"
    case communityVisited           = "community visited"
    
    case signUpPageViewed           = "signup page viewed"
    
}


extension AwesomeTrackingEvent {
    
    // MARK: - Channels library
    
    public enum Channels: String {
        case channelsClicked = "channels page clicked"
        case serieClicked = "channel series clicked"
        case episodeClicked = "channel episode clicked"
        case episodeAbandoned = "channel episode abandoned"
        case episodeWatched = "channel episode watched"
    }
    
}

extension AwesomeTrackingEvent {
    
    // MARK: - AwesomeMedia library

    public enum AwesomeMedia: String {
        case startedPlaying = "Media started playing"
        case stoppedPlaying = "Media stopped playing"
        case sliderChanged = "Media slider changed"
        case toggleFullscreen = "Media toggle full screen"
        case closeFullscreen = "Media close full screen"
        case openedMarkers = "Media opened markers"
        case closedMarkers = "Media closed markers"
        case selectedMarker = "Media selected markers"
        case openedCaptions = "Media opened captions"
        case closedCaptions = "Media closed captions"
        case selectedCaption = "Media selected caption"
        case toggledSpeed = "Media toggled speed"
        case tappedRewind = "Media tapped rewind"
        case tappedAdvance = "Media tapped advance"
        case tappedAirplay = "Media tapped airplay"
        case changedOrientation = "Media changed orientation"
        case openedFullscreenWithRotation = "Media opened full screen rotation"
        case tappedDownload = "Media tapped download"
        case deletedDownload = "Media deleted download"
        case timedOut = "Media timed out"
        case timeoutCancel = "Media timed out cancel"
        case timeoutWait = "Media timed out wait"
        case playingInBackground = "Media playing background"
    }
}

