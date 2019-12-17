//
//  ChannelCategoriesMP.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 27/05/2019.
//

import Foundation

struct ChannelCategoriesMP {
    
    static func parse(_ data: Data) -> [ChannelCategory]? {
        do {
            let decoded = try JSONDecoder().decode(ChannelCategoriesData.self, from: data)
            return decoded.data?.categories
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
}

