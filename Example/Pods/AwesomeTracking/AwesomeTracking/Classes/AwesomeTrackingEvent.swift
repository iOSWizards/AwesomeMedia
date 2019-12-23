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
    case hideApp                    = "hide app"
    case applicationInstalled       = "app_installs"
    case appInstall                 = "app install"
    case openApp                    = "open app"
    
    case onboardingStarted          = "onboarding started"
    case onboardingCompleted        = "onboarding completed"
    case quizStarted                = "mtm_quiz_started"
    case quizChosenTopics           = "mtm_quiz_chosen_topics"
    case quizCompleted              = "mtm_quiz_completed"
    
    case userLogin                  = "log in"
    case userSignup                 = "user signup"
    case signup                     = "sign up"
    case userSignupFailed           = "user signup failed"
    case userLogout                 = "user logout"
    
    case pushNotificationEnabled    = "push notification enabled"
    case pushNotificationTapped     = "push notification tapped"
    
    case courseOpened               = "course (episode) opened"
    case courseCompleted            = "complete course"
    
    case assetPlayed                = "asset played"
    case assetCompleted             = "complete asset"
    case timeMarker                 = "time marker"
    case assetDownloaded            = "file downloaded"
    
    case chapterStarted             = "chapter started"
    case chapterCompleted           = "chapter completed"
    case courseShared               = "course shared"
    
    case communityCardClicked       = "click card community"
    
    case productClicked             = "Product Clicked"
    case checkoutStarted            = "checkout started"
    case checkoutCompleted          = "checkout completed"
    case courseEnrolled             = "course enrolled"
    case salesPageViewed            = "sales page viewed"
    case trialButtonTodayTab        = "click trial button today tab"
    case trialButtonChannelsTab     = "click trial button channels tab"
    case viewTrialPage              = "view trial page"
    case purchaseTrialButtonClicked = "purchase trial button clicked"
    
    case appStoreVisited            = "app store visited"
    case appRated                   = "app rated"
    
    case membershipTabClicked       = "membership tab clicked"
    case myProgramsTabClicked       = "click tab my programs"
    case channelsTabClicked         = "click tab channels"
    case clickedSubtabQuests        = "click subtab quest"
    case clickedSubtabDiscover      = "click subtab discover quest"
    
    // MARK: - Quests app
    
    case onboardingPageViewed       = "onboarding page viewed"
    case onboardingFMQSelected      = "onboarding fmq selected"
    case onboardingFMQSkipped       = "onboarding fmq skipped"
    
    case questEnrolled              = "quest enrolled"
    case questStarted               = "start quest"
    case fmqStarted                 = "fmq started"
    case questCompleted             = "complete quest"
    
    case dayStarted                 = "start day"
    case dayClicked                 = "click day"
    case dayCompleted               = "complete day"
    case dayShared                  = "share day"
    
    case tribeVisited               = "tribe visited"
    
    case storePageClose             = "sales page closed"
    case questProductPurchased      = "quest purchased successfully"
    case questSalesPageViewed       = "view quest sales page"
    case clickQuestSalesCard        = "click sales card quest"
    
    case discoverTabViewed          = "discover tab clicked"
    case tribesTabViewed            = "tribes tab clicked"
    case myQuestsTabViewed          = "my quests tab clicked"
    
    case waitListJoined             = "waiting list joined"
    
    case communityTabViewed         = "click tab community"
    case communityVisited           = "community visited"
    
    case signUpPageViewed           = "signup page viewed"
    
    case todayTabClicked            = "click tab today"
    case profileButtonClicked       = "profile button clicked"
    case mindvalleyAppClicked       = "mindvalley app button clicked"
    case spotlightClicked           = "click tab news"
    
    case cardQuestClicked           = "click card quest"
    case cardPremiumCoursesClicked  = "click card premium courses"
    case courseClicked              = "click card course"
    case clickedTodayCourse         = "click today course card"
    case clickedTodayQuest          = "click today quest card"
    
}

// MARK: - Channels library

extension AwesomeTrackingEvent {
    
    public enum Channels: String {
        case channelsClicked = "click channel"
        case serieClicked = "channel series clicked"
        case episodeClicked = "click episode"
        case episodeAbandoned = "channel episode abandoned"
        case episodeWatched = "channel episode watched"
    }
    
}

// MARK: - AwesomeMedia library

extension AwesomeTrackingEvent {
    
    public enum AwesomeMedia: String {
        case startedPlaying = "play asset"
        case stoppedPlaying = "media stopped playing"
        case sliderChanged = "media slider changed"
        case toggleFullscreen = "media toggle full screen"
        case closeFullscreen = "media close full screen"
        case openedMarkers = "media opened markers"
        case closedMarkers = "media closed markers"
        case selectedMarker = "media selected markers"
        case openedCaptions = "media opened captions"
        case closedCaptions = "media closed captions"
        case selectedCaption = "media selected caption"
        case toggledSpeed = "media toggled speed"
        case tappedRewind = "media tapped rewind"
        case tappedAdvance = "media tapped advance"
        case tappedAirplay = "media tapped airplay"
        case changedOrientation = "media changed orientation"
        case openedFullscreenWithRotation = "media opened full screen rotation"
        case tappedDownload = "media tapped download"
        case deletedDownload = "media deleted download"
        case timedOut = "media timed out"
        case timeoutCancel = "media timed out cancel"
        case timeoutWait = "media timed out wait"
        case playingInBackground = "media playing background"
    }
}

// MARK: - Soulvana app

extension AwesomeTrackingEvent {
    
    public enum Soulvana: String {
        case userType                   = "user type"
        case appForeground              = "app foreground"
        case appBackground              = "app background"
        case viewOnboardingSlide1       = "view onboarding slide 1"
        case viewOnboardingSlide2       = "view onboarding slide 2"
        case viewOnboardingSlide3       = "view onboarding slide 3"
        case actionSkipOnboarding       = "skip slides"
        case actionGetStarted           = "get started"
        case actionLogin                = "login"
        case viewWelcomeScreen          = "view welcome screen"
        case viewLoginScreen            = "view login screen"
        case viewSignupScreen           = "view signup screen"
        case sessionStarted             = "session started"
        case resetPassword              = "reset password"
        case sessionEnded               = "session ended"
        case viewLiveImmersionTab       = "view live immersion tab"
        case viewLibraryTab             = "view library tab"
        case viewCommunityTab           = "view community tab"
        case viewSpotlightTab           = "view spotlight tab"
        case viewProfileTab             = "view profile tab"
        case subscriptionClicked        = "subscription clicked"
        case subscriptionStarted        = "subscription started"
        case viewAllSeries              = "view all series"
        case viewFavouritesSeries       = "view favourites series"
        case viewStressSeries           = "view stress series"
        case viewAnxietySeries          = "view anxiety series"
        case viewRechargingSeries       = "view recharging series"
        case viewImmersionSeries        = "view immersions series"
        case viewHealingSeries          = "view healing sessions series"
        case viewAuthorSeries           = "view author series"
        case authorClicked              = "author clicked"
        case libraryImmersionClicked    = "library immersion clicked"
        case viewLiveImmersion          = "view live immersion"
        case rsvpClicked                = "rsvp clicked"
        case shareClicked               = "share clicked"
        case immersionDemoVideoPlay     = "immersion demo video play"
        case closeImmersionScreen       = "close immersion screen"
        case subscribePremiumImmersion  = "subscribe premiun immersion click"
        case skipNotifications          = "skip notifications"
        case enableNotifications        = "enable notifications"
        case viewAuthorImmersions       = "view author immersions"
        case authorImmersionClicked     = "author immersion clicked"
        case authorScreenExit           = "author sceen exit"
        case editProfileClick           = "edit_profile click"
        case settingsClick              = "settings click"
        case becomeMember               = "become member"
        case faqClicked                 = "faq"
        case viewSubscriptionScreen     = "view subscription screen"
        case shareMediaDone             = "share media click"
    }
    
}
