//
//  HappeningsMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 25/10/17.
//

struct HappeningsMP {
    
    static func parseHappeningsFrom(_ happeningsJSON: Data) -> [Happening] {
        
        var happenings: [Happening] = []
        if let decoded = try? JSONDecoder().decode(Happenings.self, from: happeningsJSON) {
            happenings = decoded.happenings
        }
        
        return happenings
    }
    
}
