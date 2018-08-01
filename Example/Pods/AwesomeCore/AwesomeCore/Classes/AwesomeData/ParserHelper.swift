//
//  ParserHelper.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 04/07/17.
//

import Foundation

struct ParserCoreHelper {
    
    /// DateFormatter configured to work with **yyyy-MM-dd'T'HH:mm:ssZ**.
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    /// DateFormatter configured to work with **yyyy-MM-dd'T'HH:mm:ss.SSSZ**.
    static var dateFormatterSSSZ: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    
    /// DateFormatter configured to work with **dd MMM yyyy**.
    static var dateFormatter_dd_MMM_yyyy: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter
    }()
    
    static func parseDouble(_ jsonObject: [String: AnyObject], key: String) -> NSNumber {
        return NSNumber(value: AwesomeCoreParser.doubleValue(jsonObject, key: key) as Double)
    }
    
    static func parseInt(_ jsonObject: [String: AnyObject], key: String) -> NSNumber {
        return NSNumber(value: AwesomeCoreParser.intValue(jsonObject, key: key) as Int)
    }
    
    static func parseBool(_ jsonObject: [String: AnyObject], key: String) -> NSNumber {
        return NSNumber(value: AwesomeCoreParser.boolValue(jsonObject, key: key) as Bool)
    }
    
    static func parseString(_ jsonObject: [String: AnyObject], key: String) -> String {
        return AwesomeCoreParser.stringValue(jsonObject, key: key)
    }
    
    static func parseDateFormatterSSSZ(_ jsonObject: [String: AnyObject], key: String) -> Date? {
        guard let dateString = jsonObject[key] as? String else {
            return nil
        }
        return dateFormatterSSSZ.date(from: dateString)
    }
    
    static func parseDate(dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }
    
}
