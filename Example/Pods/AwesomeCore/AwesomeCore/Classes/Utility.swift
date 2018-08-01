//
//  Utility.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 18/08/2017.
//

import Foundation

public class Utility {
    
    static func log(_ message: String, forFile: String = #file, forFunction: String = #function) {
        var className = forFile.components(separatedBy: "/").last ?? forFile
        className = className.replacingOccurrences(of: ".swift", with: "")
        NSLog("\(className).\(forFunction):\(message)")
    }
    
    static func loadJSONFrom(fileWithName: String) -> [String: AnyObject]? {
        // here we're loading a file using the current bundle to load this file inside another bundle.
        let bundle = Bundle(for: self).url(forResource: "AwesomeCore", withExtension: "bundle")
        if let path = Bundle(url: bundle!)?.path(forResource: fileWithName, ofType: "json") {
            do {
                let jsonData = try? NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    return try! JSONSerialization.jsonObject(
                        with: jsonData! as Data,
                        options: JSONSerialization.ReadingOptions.mutableContainers
                        ) as! [String: AnyObject]
                }
            }
        }
        return nil
    }
    
    /// Compare a pair of Arrays.
    ///
    /// - Parameters:
    ///   - lhs: an Array of objects conforming to Equatable protocol.
    ///   - rhs: an Array of objects conforming to Equatable protocol.
    /// - Returns: true in case they are equal or false otherwise.
    static func equals<T : Equatable>(_ lhs: [T]?, _ rhs: [T]?) -> Bool {
        if lhs == nil && rhs == nil {
            return true
        } else if lhs != nil && rhs != nil {
            return lhs! == rhs!
        }
        return false
    }
    
    /// Counts occurance of string in text
    ///
    /// - Parameters:
    ///   - char: Character to search in text
    ///   - inText: Text context to search
    /// - Returns: Number of characters found in text
    public static func count(_ char: Character, inText text: String?) -> Int {
        guard let text = text else {
            return 0
        }
        
        let characters: [Character] = text.filter { $0 == char }
        return characters.count
    }
    
}
