//
//  QuestAssetsMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

struct QuestAssetMP {
    
    static func parseQuestAssetFrom(_ questAssetJSON: Data) -> QuestAsset? {
        
        var asset: QuestAsset?
        if let decoded = try? JSONDecoder().decode(QuestAssetKey.self, from: questAssetJSON) {
            asset = decoded.asset
        }
        
        return asset
    }
    
}
