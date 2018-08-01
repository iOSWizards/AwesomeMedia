//
//  CompletionProgressMP.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 14/07/2017.
//

import Foundation

public struct CompletionProgressMP {
    
    /// Parses a JSON documento to a CompletionProgress object.
    ///
    /// - Parameter jsonObject: JSON document as [String: AnyObject]
    /// - Returns: CompletionProgress object.
    public static func parseCompletionProgressFrom(jsonObject: [String: AnyObject]) -> CompletionProgress? {
        return CompletionProgress(
            totalChapters: ParserCoreHelper.parseInt(jsonObject, key: "total_chapters").intValue,
            chaptersRead: ParserCoreHelper.parseInt(jsonObject, key: "number_of_chapters_read").intValue,
            completionPercentage: ParserCoreHelper.parseDouble(jsonObject, key: "completion_percentage").doubleValue
        )
    }
    
}
