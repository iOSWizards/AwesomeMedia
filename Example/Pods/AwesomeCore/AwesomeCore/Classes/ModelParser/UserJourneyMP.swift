//
//  UserJourneyMP.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 08/03/2019.
//

import Foundation

struct UserJourneyMP {
    
    static func parse(_ data: Data) -> BubbleQuizSubmitAnswersResponse? {
        do {
            let decoded = try JSONDecoder().decode(UserJourney.self, from: data)
            return decoded.data?.journey
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
}
