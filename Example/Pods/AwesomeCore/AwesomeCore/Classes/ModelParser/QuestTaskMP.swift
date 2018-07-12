//
//  QuestTaskMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

struct QuestTaskMP {
    
    static func parseQuestTasksFrom(_ questTasksJSON: Data) -> [QuestTask] {
        
        var tasks: [QuestTask] = []
        if let decoded = try? JSONDecoder().decode(QuestTasks.self, from: questTasksJSON) {
            tasks = decoded.tasks
        }
        
        return tasks
    }
    
}
