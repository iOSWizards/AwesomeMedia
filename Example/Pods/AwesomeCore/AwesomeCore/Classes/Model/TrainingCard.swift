//
//  TrainingCard.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 05/09/17.
//

import Foundation

public struct TrainingCard: Codable {
    
    public let id: Int
    public let academyId: Int
    public let courseId: Int
    public let date: Date?
    public let title: String
    public let author: String
    public let placeholder: String
    public let imageUrl: String
    public let categories: [String]
    public let href: String
    public let studentCount: Int
    public let rating: Double
    public let completionPercentage: Double
    
    init(id: Int,
         academyId: Int,
         courseId: Int,
         date: Date?,
         title: String,
         author: String,
         placeholder: String,
         imageUrl: String,
         categories: [String],
         href: String,
         studentCount: Int,
         rating: Double,
         completionPercentage: Double) {
        
        self.id = id
        self.academyId = academyId
        self.courseId = courseId
        self.date = date
        self.title = title
        self.author = author
        self.placeholder = placeholder
        self.imageUrl = imageUrl
        self.categories = categories
        self.href = href
        self.studentCount = studentCount
        self.rating = rating
        self.completionPercentage = completionPercentage
    }
}
