//
//  UserJourney.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 08/03/2019.
//

import Foundation

public struct UserJourney: Codable {
    public let data: JourneyData?
}

public struct JourneyData: Codable {
    public let journey: BubbleQuizSubmitAnswersResponse?
}
