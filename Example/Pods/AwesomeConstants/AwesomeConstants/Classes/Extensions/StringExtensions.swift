//
//  StringExtensions.swift
//  Quests
//
//  Created by Evandro Harrison Hoffmann on 1/26/17.
//  Copyright © 2017 Mindvalley. All rights reserved.
//

import Foundation

extension String {

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    public func toDate(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }

    public var date: Date? {
        return date()
    }

    public func date(_ callback:@escaping (Date?) -> Void) {
        DispatchQueue.main.async {
            callback(self.date())
        }
    }

    public func date(withFormat format: String? = nil) -> Date? {
        let date = self.replacingOccurrences(of: ".000000Z", with: "Z")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: date)
    }
    
    public func dateMiliSeconds(withFormat format: String? = nil) -> Date? {
        let date = self.replacingOccurrences(of: ".000000Z", with: "Z")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: date)
    }

    public func nsDate(withFormat format: String? = nil) -> NSDate? {
        if let date = date(withFormat: format) {
            return NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
        }
        return nil
    }

    public func filtering(_ string: String) -> String? {
        if self.contains(string) {
            return nil
        }
        return self
    }
}
