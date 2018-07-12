//
//  PaginationData.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 31/08/2017.
//

import Foundation

public struct PaginationData {
    
    public let total: Int
    public let page: String
    public let limit: Int
    public let previous: String
    public let next: String
    
    init(total: Int, page: String, limit: Int, previous: String, next: String) {
        self.total = total
        self.page = page
        self.limit = limit
        self.previous = previous
        self.next = next
    }
    
    init(dict: [String: AnyObject]) {
        self.total = AwesomeCoreParser.intValue(dict, key: "total")
        self.page = AwesomeCoreParser.stringValue(dict, key: "page")
        self.limit = AwesomeCoreParser.intValue(dict, key: "limit")
        self.previous = AwesomeCoreParser.stringValue(dict, key: "previous")
        self.next = AwesomeCoreParser.stringValue(dict, key: "next")
    }
}
