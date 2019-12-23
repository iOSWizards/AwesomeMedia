//
//  MediaListMP.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 31/05/2019.
//

import Foundation


struct MediaListMP {
    
    static func parseMediaFrom(_ json: Data) -> [QuestMedia]? {
        do {
            let decoded = try JSONDecoder().decode(MediaListDataKey.self, from: json)
            return decoded.data.mediaList
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
    
}
