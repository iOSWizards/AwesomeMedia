//
//  FreeEpisodesMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 16/03/18.
//

import Foundation

struct FreeEpisodesMP {
    
    static func parsefreeEpisodesFrom(_ freeEpisodesJson: Data) -> FreeCourses {
        
        if let decoded = try? JSONDecoder().decode(FreeCourses.self, from: freeEpisodesJson) {
            return decoded
        } else {
            return FreeCourses(courses: [])
        }
    }
    
}

