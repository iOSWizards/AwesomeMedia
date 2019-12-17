//
//  AwesomeCore+UserJourney.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 08/03/2019.
//

import Foundation

public extension AwesomeCore {
    
    public static func getUserJourney(distinctId: String, cardLimit: Bool = false, params: AwesomeCoreNetworkServiceParams, response: @escaping (BubbleQuizSubmitAnswersResponse?, ErrorData?) -> Void) {
        UserJourneyNS.shared.getUserJourney(distinctId: distinctId, cardLimit: cardLimit, params: .standard) { (answersResponse, error) in
            DispatchQueue.main.async {
                response(answersResponse, error)
            }
        }
    }
}
