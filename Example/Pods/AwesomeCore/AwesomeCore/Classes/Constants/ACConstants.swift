//
//  ACConstants.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 04/07/2017.
//

import Foundation

final public class ACConstants {
    
    static var shared = ACConstants()
    
    private init() {}
    
    // MARK: - Production APIpo
    
    public let api_id          = "5206511708206452"
    public let api_key         = "2b3bad56a8e1cd7d9c04eb746089fb7a"
    
    public let basePROD_URL           = "https://api.elula.com/v2/"
    public let baseDEV_URL            = "http://api-elula.mvstg.com/v2/"
    public let baseMembershipPROD_URL = "https://home.mindvalley.com/api/v2/membership/"
    public let baseMembershipDEV_URL  = "https://home.mvstg.com/api/v2/membership/"
    public let baseLibraryPROD_URL    = "https://home.mindvalley.com/api/v2/library/"
    public let baseLibraryDEV_URL     = "https://home.mvstg.com/api/v2/library/"
    public let baseSwaggerPROD_URL    = "https://home.mindvalley.com/api/v2/"
    public let baseSwaggerDEV_URL     = "https://home.mvstg.com/api/v2/"
    public let baseDiscoverPROD_URL   = "https://home.mindvalley.com/api/v2/discover/"
    public let baseDiscoverDEV_URL    = "https://home.mvstg.com/api/v2/discover/"
    public let baseQuestsPROD_URL     = "https://api.tribelearn.com/graph/"
    public let baseQuestsDEV_URL      = "http://api-staging.tribelearn.com/graph"
    public let baseProfileV1PROD_URL  = "https://profile.mindvalley.com/api/v1/"
    public let baseProfileV1DEV_URL   = "http://profile.mvstg.com/api/v1/"
    public let baseChannelsPROD_URL   = "https://home.mindvalley.com/api/v2/channels/"
    public let baseChannelsDEV_URL    = "https://home-bleeding-edge.mvstg.com/api/v2/channels/"
    public let baseEventsPROD_URL     = "https://home.mindvalley.com/api/v2/event/"
    public let baseEventsDEV_URL      = "https://home.mvstg.com/api/v2/event/"
    
    public var baseURL : String {
        return AwesomeCore.shared.prodEnvironment ? basePROD_URL : baseDEV_URL
    }
    
    public var baseMembershipURL : String {
        return AwesomeCore.shared.prodEnvironment ? baseMembershipPROD_URL : baseMembershipDEV_URL
    }
    
    public var baseLibraryURL : String {
        return AwesomeCore.shared.prodEnvironment ? baseLibraryPROD_URL : baseLibraryDEV_URL
    }
    
    public var baseSwaggerURL: String {
        return AwesomeCore.shared.prodEnvironment ? baseSwaggerPROD_URL : baseSwaggerDEV_URL
    }
    
    public var baseDiscoverURL: String {
        return AwesomeCore.shared.prodEnvironment ? baseDiscoverPROD_URL : baseDiscoverDEV_URL
    }
    
    public var questsURL: String {
        return AwesomeCore.shared.prodEnvironment ? baseQuestsPROD_URL : baseQuestsDEV_URL
    }
    
    public var profileV1URL: String {
        return AwesomeCore.shared.prodEnvironment ? baseProfileV1PROD_URL : baseProfileV1DEV_URL
    }
    
    public var baseChannelsURL: String {
        return AwesomeCore.shared.prodEnvironment ? baseChannelsPROD_URL : baseChannelsDEV_URL
    }
    
    public var baseEventsURL: String {
        return AwesomeCore.shared.prodEnvironment ? baseEventsPROD_URL : baseEventsDEV_URL
    }
    
    // MARK: - API Calls
    
    public var academiesURL         : String { return "\(baseURL)mobile/academies" }
    public var academyURL           : String { return "\(baseURL)mobile/academies/%d" }
    public var coursesURL           : String { return "\(baseURL)mobile/courses?per_page=%@&page=%@" }
    public var academyCourseURL     : String { return "\(baseURL)academies/%d/mobile/courses/%d" }
    public var academyCoursesURL    : String { return "\(baseURL)academies/%@/mobile/courses?per_page=%@&page=%@" }
    public var userProfileURL       : String { return "\(baseURL)mobile/profile" }
    public var userProfilePictureURL: String { return "\(profileV1URL)users/upload_profile_photo" }
    public var userProfileForToken  : String { return "\(profileV1URL)users/user_profile_for_token"}
    public var updateUserProfileForToken  : String { return "\(profileV1URL)users/update_user_profile_for_token"}
    
    public var academiesTypedURL    : String { return "\(baseURL)mobile/academies?type=%@&per_page=%@" }
    
    public var eventsAttendeesURL   : String { return "\(baseEventsURL)%@/attendees?page=%@"}
    public var eventsAttendeesByTagURL  : String { return "\(baseEventsURL)%@/filter_attendees_by_tag"}
    public var eventPurchaseStatusURL   : String { return "\(baseEventsURL)%@/purchase_status"}
    public var eventRegistrationURL : String { return "\(baseEventsURL)%@/event_registration?arrival_date=%@&departure_date=%@"}
    
    public var newTrainingsURL      : String { return "\(baseMembershipURL)new_trainings" }
    public var lastViewedURL        : String { return "\(baseMembershipURL)last_viewed" }
    public var categoriesURL        : String { return "\(baseMembershipURL)categories" }
    public var categoryTrainingsURL : String { return "\(baseMembershipURL)category_trainings?category=%@" }
    public var membershipAcademies  : String { return "\(baseMembershipURL)academies" }
    public var memberBenefits       : String { return "\(baseMembershipURL)member_benefits"}
    public var happenings           : String { return "\(baseDiscoverURL)happenings" }
    public var communities          : String { return "\(baseSwaggerURL)user_communities" }
    public var quizCategories       : String { return "\(baseSwaggerURL)quiz/choices" }
    public var quizResultsCourses   : String { return "\(baseSwaggerURL)quiz/results" }
    public var quizAddProduct       : String { return "\(baseSwaggerURL)products" }
    public var freeEpisodes         : String { return "\(baseMembershipURL)mtm_courses?filter=free" }
    public var addSignupDetails     : String { return "\(baseSwaggerURL)signup/details" }
    public var channels             : String { return "\(baseChannelsURL)" }
    public var channelsWithAcademy  : String { return "\(baseChannelsURL)%d" }
    public var series               : String { return "\(baseChannelsURL)%d/%d" }
    
    public var librarySubscriptionURL  : String { return "\(baseLibraryURL)subscriptions" }
    public var librarySingleCoursesURL : String { return "\(baseLibraryURL)single_courses" }
    public var libraryCollectionsURL   : String { return "\(baseLibraryURL)collections" }
    
    public var userMeURL               : String { return "\(baseSwaggerURL)me.json" }
    
    // MARK: - Builders
    
    /// Build an URL with the given format and parameters, in case there's no parameter the URL format will be returned.
    ///
    /// - Parameters:
    ///   - format: URL format like: http://https://api.elula.com/v2/academies/%d/mobile/courses/%d
    ///   - params: inputs to be inputed in the URL
    /// - Returns: URL with the given parameters.
    public static func buildURLWith(format: String, with params: Int...) -> String {
        let arr: [CVarArg] = params
        return String(format: format, arguments: arr)
    }
    
    public static func buildURLWith(format: String, with params: String...) -> String {
        let arr: [CVarArg] = params
        return String(format: format, arguments: arr)
    }
    
}
