//
//  HashBuilder.swift
//  AwesomeCore
//
//  Created by Antonio on 11/23/17.
//

import UIKit

struct HashBuilder {
    
    let data: Data
    let method: URLMethod
    let url: String
    
    init(data: Data, method: URLMethod, url: String) {
        self.data = data
        self.method = method
        self.url = url
    }

}

extension HashBuilder: Hashable {
    
    static func ==(lhs: HashBuilder, rhs: HashBuilder) -> Bool {
        if lhs.data != rhs.data {
            return false
        }
        if lhs.method != rhs.method {
            return false
        }
        if lhs.url != rhs.url {
            return false
        }
        return true
    }
    
    var hashValue: Int {
        return data.hashValue ^ method.hashValue ^ url.hashValue //^ hashForArray(headers)
    }
    
    // MARK: - Helpers
    
    private static func equalArray(ar1: [[String]], ar2: [[String]]) -> Bool {
        return ar1.elementsEqual(ar2, by: { $0 == $1 })
    }
    
    private func hashForArray(_ array: [[String]]) -> Int {
        var hashValue = 0
        for innerArray in array {
            for a in innerArray {
                hashValue ^= a.hashValue
            }
        }
        return hashValue
    }
    
}
