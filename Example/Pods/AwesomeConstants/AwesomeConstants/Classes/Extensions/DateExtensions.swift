//
//  Date+Formatting.swift
//  Quests
//
//  Created by Evandro Harrison Hoffmann on 1/26/17.
//  Copyright © 2017 Mindvalley. All rights reserved.
//

import Foundation

extension Date {
    public func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    public func days(toDate date: Date) -> Int {
        // Replace the hour (time) of both dates with 00:00
        let date1 = Calendar.current.startOfDay(for: self)
        let date2 = Calendar.current.startOfDay(for: date)

        let components = Calendar.current.dateComponents([Calendar.Component.day], from: date1, to: date2)

        if let days = components.day {
            return days
        }
        return 0
    }

    public func hours(toDate date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.hour], from: self, to: date)

        if let hours = components.hour {
            return hours
        }
        return 0
    }

    public func minutes(toDate date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.minute], from: self, to: date)

        if let minutes = components.minute {
            return minutes
        }
        return 0
    }

    public var lapseString: String {
        let daysAgo = self.days(toDate: Date())
        let hoursAgo = self.hours(toDate: Date())
        let minutesAgo = self.minutes(toDate: Date())

        if daysAgo > 1 {
            return self.toString(format: "MMM dd").appendingFormat(" %@ %@", "at".localized, self.toString(format: "h:mm a").lowercased())
        } else if daysAgo == 1 {
            return "yesterday".localized
        } else if hoursAgo > 1 {
            return String(format: "%d %@", hoursAgo, "hours_ago".localized)
        } else if hoursAgo == 1 {
            return "1_hour_ago".localized
        } else if minutesAgo > 1 {
            return String(format: "%d %@", minutesAgo, "minutes_ago".localized)
        } else {
            return "now".localized
        }
    }

    public func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }

    public func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }

    public func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }

    public func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }

    public func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    public func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    public func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }

    public func offset(from date: Date) -> String {
        if years(from: date)   == 1 { return "\(years(from: date)) \("year".localized) \("ago".localized)" }
        if years(from: date)   > 1 { return "\(years(from: date)) \("years".localized) \("ago".localized)" }
        if months(from: date)  == 1 { return "\(months(from: date)) \("month".localized) \("ago".localized)" }
        if months(from: date)  > 1 { return "\(months(from: date)) \("months".localized) \("ago".localized)" }
        if weeks(from: date)   == 1 { return "\(weeks(from: date)) \("week".localized) \("ago".localized)" }
        if weeks(from: date)   > 1 { return "\(weeks(from: date)) \("weeks".localized) \("ago".localized)" }
        if days(from: date)    == 1 { return "\(days(from: date)) \("day".localized) \("ago".localized)" }
        if days(from: date)    > 1 { return "\(days(from: date)) \("days".localized) \("ago".localized)" }
        if hours(from: date)   == 1 { return "\(hours(from: date)) \("hour".localized) \("ago".localized)" }
        if hours(from: date)   > 1 { return "\(hours(from: date)) \("hours".localized) \("ago".localized)" }
        if minutes(from: date) == 1 { return "\(minutes(from: date)) \("minute".localized) \("ago".localized)" }
        if minutes(from: date) > 1 { return "\(minutes(from: date)) \("minutes".localized) \("ago".localized)" }
        if seconds(from: date) == 1 { return "\(seconds(from: date)) \("second".localized) \("ago".localized)" }
        if seconds(from: date) > 1 { return "\(seconds(from: date)) \("seconds".localized) \("ago".localized)" }
        return "Just now".localized
    }

    public func withTime(_ time: String, format: String = "HH:mm") -> Date {
        let date = self.toString(format: "yyyy/MM/dd")
        return date.appending(" \(time)").toDate(format: "yyyy/MM/dd \(format)")
    }

    public static var tomorrow: Date? {
        let today = Date()
        return Calendar.current.date(byAdding: .day, value: 1, to: today)
    }

    public func getElapsedInterval() -> String {

        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())

        return "\(interval.year ?? 0) years, \(interval.month ?? 0) months, \(interval.day ?? 0) days, \(interval.hour ?? 0) hours, \(interval.minute ?? 0) minutes, \(interval.second ?? 0) seconds"
    }

}

extension NSDate {

    public static func toString(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

}
