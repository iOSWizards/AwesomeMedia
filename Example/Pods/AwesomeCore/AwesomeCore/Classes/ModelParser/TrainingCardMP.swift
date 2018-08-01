//
//  TrainingCardMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 05/09/17.
//

import Foundation

struct TrainingCardMP {
    
    static func parseTrainingCardFrom(_ trainingCardJSON: [String: AnyObject]) -> TrainingCard? {
        
        var categoriesArray: [String] = []
        if let categories = trainingCardJSON["categories"] as? [String] {
            for category in categories {
                categoriesArray.append(category)
            }
        }
        
        return TrainingCard(id: AwesomeCoreParser.intValue(trainingCardJSON, key: "id"),
                            academyId: AwesomeCoreParser.intValue(trainingCardJSON, key: "academy_id"),
                            courseId: AwesomeCoreParser.intValue(trainingCardJSON, key: "course_id"),
                            date: AwesomeCoreParser.dateValue(trainingCardJSON, key: "date"),
                            title: AwesomeCoreParser.stringValue(trainingCardJSON, key: "title"),
                            author: AwesomeCoreParser.stringValue(trainingCardJSON, key: "author"),
                            placeholder: AwesomeCoreParser.stringValue(trainingCardJSON, key: "placeholder"),
                            imageUrl: AwesomeCoreParser.stringValue(trainingCardJSON, key: "image_url"),
                            categories: categoriesArray,
                            href: AwesomeCoreParser.stringValue(trainingCardJSON, key: "href"),
                            studentCount: AwesomeCoreParser.intValue(trainingCardJSON, key: "student_count"),
                            rating: AwesomeCoreParser.doubleValue(trainingCardJSON, key: "rating"))
    }
    
    public static func parseTrainingsFrom(jsonObject: [String: AnyObject]) -> [TrainingCard] {
        var trainings = [TrainingCard]()
        
        guard let trainingsDict = jsonObject["training_cards"] as? [[String: AnyObject]] else {
            return trainings
        }
        
        for trainingDict in trainingsDict {
            if let t = parseTrainingCardFrom(trainingDict) {
                trainings.append(t)
            }
        }
        
        return trainings
    }
    
}
