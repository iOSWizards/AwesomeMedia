//
//  Section.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 10/07/17.
//

import Foundation

public struct Section : Codable, Equatable {
    
    public let courseChapterSectionId: Int
    public let title: String
    public let type: String
    public let markers: [Marker]
    public let position: Int
    public let body: String?
    public let mode: String?
    public let duration: Int?
    public var continueAtTime: Double?
    public let downloadable: Bool?
    public let embedCode: String?
    public let imageLink: String?
    public let assetCoverUrl: String?
    public let assetUrl: String?
    public let assetSize: Int?
    public let assetFileExtension: String?
    public let assetStreamingUrl: String?
    public var courseChapterId: Int
    public var courseId: Int
    public var assetId: Int
    
    public init(courseChapterSectionId: Int,
         title: String,
         type: String,
         markers: [Marker],
         position: Int,
         body: String? = nil,
         mode: String? = nil,
         duration: Int? = nil,
         continueAtTime: Double? = nil,
         downloadable: Bool? = nil,
         embedCode: String? = nil,
         imageLink: String? = nil,
         assetCoverUrl: String? = nil,
         assetUrl: String? = nil,
         assetSize: Int? = nil,
         assetFileExtension: String? = nil,
         assetStreamingUrl: String? = nil,
         courseChapterId: Int = -1,
         courseId: Int = -1,
         assetId: Int = -1) {
        
        self.courseChapterSectionId = courseChapterSectionId
        self.title = title
        self.type = type
        self.markers = markers
        self.position = position
        self.body = body
        self.mode = mode
        self.duration = duration
        self.continueAtTime = continueAtTime
        self.downloadable = downloadable
        self.embedCode = embedCode
        self.imageLink = imageLink
        self.assetCoverUrl = assetCoverUrl
        self.assetUrl = assetUrl
        self.assetSize = assetSize
        self.assetFileExtension = assetFileExtension
        self.assetStreamingUrl = assetStreamingUrl
        self.courseChapterId = courseChapterId
        self.courseId = courseId
        self.assetId = assetId
    }
    
    // MARK: - Computed properties
    
    public var mediaPath: String? {
        
        if let url = assetStreamingUrl, !url.isEmpty {
            return url
        } else if let url = assetUrl, !url.isEmpty {
            return url
        }
        
        return nil
    }
    
    // MARK: - Asset Size
    
    public var assetFileSize: String {
        
        guard let assetSize = assetSize else {
            return ""
        }
        
        // MB
        if assetSize >= 1048576 {
            return String(format:"%0.1f MB", Float(assetSize) / 1048576)
        } else {
            // KB
            return String(format:"%0.1f KB", Float(assetSize) / 1024)
        }
    }
    
}

// MARK: - Equatable

extension Section {
    
    static public func ==(lhs: Section, rhs: Section) -> Bool {
        if lhs.courseChapterSectionId != rhs.courseChapterSectionId {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        if lhs.markers != rhs.markers {
            return false
        }
        if lhs.courseChapterId != rhs.courseChapterId {
            return false
        }
        if lhs.courseId != rhs.courseId {
            return false
        }
        return true
    }
    
}

