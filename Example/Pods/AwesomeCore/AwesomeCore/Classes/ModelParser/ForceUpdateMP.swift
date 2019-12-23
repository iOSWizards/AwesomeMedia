//
//  ForceUpdateMP.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 03/04/2019.
//

import Foundation

struct ForceUpdateMP {
    
    static func parse(_ data: Data) -> FUVersionInfo? {
        do {
            let decoded = try JSONDecoder().decode(FUData.self, from: data)
            return decoded.data?.app?.settings
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
}
