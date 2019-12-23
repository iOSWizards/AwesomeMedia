//
//  QuestAsset.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/2/17.
//

import Foundation

public enum QuestAssetVideoRenditionType: String {
    case hls
    case mp4
    case webm
    case videoposter1
    case videoposter2
    case videoposter3
}

public enum QuestAssetAudioRenditionType: String {
    case mp3
    case ogg
}

public struct QuestAsset: Codable, Equatable {
    
    public let contentType: String?
    public let duration: Double?
    public let edgeUrl: String?
    public let filesize: Int?
    public let id: String?
    public let markers: [QuestMarker]?
    public let name: String?
    public let overmindId: String?
    public var renditions: [QuestRendition]?
    public let secure: Bool?
    public let status: String?
    public let thumbnailUrl: String?
    public let url: String?
    public let captions: [QuestCaption]?
    
    init(contentType: String?, duration: Double?, edgeUrl: String?, filesize: Int?,
         id: String?, markers: [QuestMarker]?, name: String?, overmindId: String?,
         renditions: [QuestRendition]?, secure: Bool?, status: String?, thumbnailUrl: String?,
         url: String?, captions: [QuestCaption]?) {
        self.contentType = contentType
        self.duration = duration
        self.edgeUrl = edgeUrl
        self.filesize = filesize
        self.id = id
        self.markers = markers
        self.name = name
        self.overmindId = overmindId
        self.renditions = renditions
        self.secure = secure
        self.status = status
        self.thumbnailUrl = thumbnailUrl
        self.url = url
        self.captions = captions
    }
    
    // MARK: - Computed properties
    
    public var currentTime: Double? {
        set {
            UserDefaults.standard.set(newValue, forKey: overmindId ?? "")
        }
        get {
            return UserDefaults.standard.double(forKey: overmindId ?? "")
        }
    }
    
    // MARK: - Asset Size
    
    public var assetFileSize: String {
        guard let filesize = filesize else {
            return ""
        }
        
        // MB
        if filesize >= 1048576 {
            return String(format:"%0.1f MB", Float(filesize / 1048576))
        } else {
            // KB
            return String(format:"%0.1f KB", Float(filesize / 1024))
        }
    }
    
    // MARK: - Renditions
    
    public func videoUrl(withType type: QuestAssetVideoRenditionType = .hls) -> String? {
        guard let renditions = renditions, renditions.count > 0 else {
            return url
        }
        
        let streamingRendition = videoRendition(withType: type)
        
        if streamingRendition?.status == "error" {
            return videoRendition(withType: .mp4)?.url
        }
        
        return streamingRendition?.url
    }
    
    public func videoRendition(withType type: QuestAssetVideoRenditionType) -> QuestRendition? {
        
        guard let renditions = renditions, renditions.count > 0 else {
            return nil
        }
        
        for rendition in renditions where rendition.id == type.rawValue {
            return rendition
        }
        
        return nil
    }
    
    public func audioUrl(withType type: QuestAssetAudioRenditionType = .mp3) -> String? {
        guard let renditions = renditions, renditions.count > 0 else {
            return url
        }
        
        for rendition in renditions {
            if rendition.id == type.rawValue {
                if let url = rendition.url, url.count > 0 {
                    return url
                }
            }
        }
        
        return url
    }
    
    public func url(forType type: String) -> String? {
        if type == "audio" {
            return audioUrl()
        } else if type == "video" {
            return videoUrl()
        }
        
        return url
    }
    
    public var durationString: String {
        guard let duration = duration else { return "" }
        if duration == 0 {
            return ""
        }
        return duration.timeString
    }
    
}

// MARK: - JSON Key

public struct QuestAssetKey: Codable {
    
    public let asset: QuestAsset
    
}

// MARK: - Equatable

extension QuestAsset {
    public static func ==(lhs: QuestAsset, rhs: QuestAsset) -> Bool {
        if lhs.contentType != rhs.contentType {
            return false
        }
        if lhs.duration != rhs.duration {
            return false
        }
        if lhs.edgeUrl != rhs.edgeUrl {
            return false
        }
        if lhs.filesize != rhs.filesize {
            return false
        }
        if lhs.id != rhs.id {
            return false
        }
        if !Utility.equals(lhs.markers, rhs.markers) {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.overmindId != rhs.overmindId {
            return false
        }
        if !Utility.equals(lhs.renditions, rhs.renditions) {
            return false
        }
        if lhs.secure != rhs.secure {
            return false
        }
        if lhs.status != rhs.status {
            return false
        }
        if lhs.thumbnailUrl != rhs.thumbnailUrl {
            return false
        }
        if lhs.url != rhs.url {
            return false
        }
        if !Utility.equals(lhs.captions, rhs.captions) {
            return false
        }
        return true
    }
    
}

