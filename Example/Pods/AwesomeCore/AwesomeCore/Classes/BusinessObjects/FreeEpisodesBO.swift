//
//  FreeEpisodesBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 16/03/18.
//

import Foundation

public struct FreeEpisodesBO {
    
    static var freeEpisodesNS = FreeEpisodesNS.shared
    public static var shared = FreeEpisodesBO()
    
    private init() {}
    
    public static func fetchFreeEpisodes(forcingUpdate: Bool = false, response: @escaping ([FreeCourse], ErrorData?) -> Void) {
        freeEpisodesNS.fetchFreeEpisodes(forcingUpdate: forcingUpdate) { (courses, error) in
            DispatchQueue.main.async {
                response(courses, error)
            }
        }
    }
}


