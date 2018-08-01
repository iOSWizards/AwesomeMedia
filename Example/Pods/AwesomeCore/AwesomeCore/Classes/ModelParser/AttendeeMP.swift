//
//  AttendeeMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 6/18/18.
//

import Foundation

struct AttendeeMP {
    
    static func parseAttendeesFrom(_ json: Data) -> [Attendee] {
        
        if let decoded = try? JSONDecoder().decode([AttendeeUserKey].self, from: json) {
            return decoded.map { attendee in
                attendee.user
            }
        } else {
            return []
        }
    }
    
}

