//
//  Extensions.swift
//  AwesomeData
//
//  Created by Evandro Harrison Hoffmann on 16/08/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

extension Data {
    
    public var attributedStringAC: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options:[
                NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
}

extension String {
    public var utf8DataAC: Data? {
        return data(using: String.Encoding.utf8)
    }
    
    public var stripHTMLAC: String? {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var cleanHTMLAC: String{
        var allHTMLText = self
        allHTMLText = allHTMLText.replacingOccurrences(of: "                  ", with: "")
        allHTMLText = allHTMLText.replacingOccurrences(of: "<br></li>", with: "</li>")
        allHTMLText = allHTMLText.replacingOccurrences(of: "<br></p>", with: "</p>")
        allHTMLText = allHTMLText.replacingOccurrences(of: "\n", with: "")
        allHTMLText = allHTMLText.replacingOccurrences(of: "\r", with: "")
        allHTMLText = allHTMLText.replacingOccurrences(of: "<p></p>", with: "")
        allHTMLText = allHTMLText.replacingOccurrences(of: "<ul></ul>", with: "")
        allHTMLText = allHTMLText.replacingOccurrences(of: "</ol>", with: "</ol><br>")
        allHTMLText = allHTMLText.replacingOccurrences(of: "</ul>", with: "</ul><br>")
        allHTMLText = allHTMLText.replacingOccurrences(of: "</h2><p>", with: "</h2><br><p>")
        return allHTMLText
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension Int {
    
    public var secondsToTimeString: String {
        
        if self <= 0 {
            return ""
        }
        
        let hours = Int(self / 3600)
        let minutes = Int((self / 60) % 60)
        
        if hours > 0 {
            return String(format: "%1d \("hr".localized) \(minutes > 9 ? "%2d" : "%1d") \("min".localized)", hours, minutes)
        }
        if minutes > 0 {
            return String(format: "%0.2d " + "minutes".localized, minutes)
        }
        let seconds = self % 60
        return String(format: "%0.2d " + "seconds".localized, seconds)
        
    }
}

extension Float {
    func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    var timeString: String {
        
        let ti = NSInteger(self)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        if hours > 0 {
            return String(format: "%d \("hours".localized) %d \("minutes".localized)", hours, minutes)
        } else if minutes > 0 {
            return String(format: "%d \("min".localized)", minutes)
        }
        
        return String(format: "%d \("seconds".localized)", seconds)
    }
    
}

extension NSAttributedString {
    func heightWithConstrainedWidthAC(_ width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func widthWithConstrainedHeightAC(_ height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension TimeInterval {
    
    var days: String {
        return String(format:"%02d", Int((self/86400)))
    }
    
}

extension Date {
    
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    func days(toDate date: Date) -> Int {
        // Replace the hour (time) of both dates with 00:00
        let date1 = Calendar.current.startOfDay(for: self)
        let date2 = Calendar.current.startOfDay(for: date)
        
        let components = Calendar.current.dateComponents([Calendar.Component.day], from: date1, to: date2)
        
        if let days = components.day {
            return days
        }
        return 0
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

extension String {
    
    var date: Date? {
        return date()
    }
    
    func date(_ callback:@escaping (Date?) -> Void) {
        DispatchQueue.main.async {
            callback(self.date())
        }
    }
    
    func date(withFormat format: String? = nil) -> Date? {
        let date = self.replacingOccurrences(of: ".000000Z", with: "Z")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format ?? "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: date)
    }
    
}
