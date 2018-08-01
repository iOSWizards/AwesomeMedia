//
//  PaginationDataMP.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 31/08/2017.
//

import Foundation

struct PaginationDataMP {
    
    static func parsePaginationFrom(_ paginationJSON: [String: AnyObject], key: String) -> PaginationData? {
        guard let metaJSON = paginationJSON[key] as? [String: AnyObject] else {
            return nil
        }
        return PaginationData(dict: metaJSON)
    }
}
