//
//  AwesomeMediaParams.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/9/18.
//

import Foundation

public enum AwesomeMediaParamsKey: String {
    case autoplay
}

public struct AwesomeMediaParams {
    public var url: String?
    public var youtubeUrl: String?
    public var coverUrl: String?
    public var author: String?
    public var title: String?
    public var duration: Int = 0
    public var markers: [AwesomeMediaMarker] = []
    public var captions: [AwesomeMediaCaption] = []
    public var size: String?
    public var type: String?
    public var params: [String: Any] = [:]
    
    public init(url: String? = nil,
                youtubeUrl: String? = nil,
                coverUrl: String? = nil,
                author: String? = nil,
                title: String? = nil,
                duration: Int = 0,
                markers: [AwesomeMediaMarker] = [],
                captions: [AwesomeMediaCaption] = [],
                size: String? = nil,
                type: String? = nil,
                params: [String: Any] = [:]) {
        self.url = url
        self.youtubeUrl = youtubeUrl
        self.coverUrl = coverUrl
        self.author = author
        self.title = title
        self.duration = duration
        self.markers = markers
        self.captions = captions
        self.size = size
        self.type = type
        self.params = params
    }
    
    // MARK: - Captions
    
    public func caption(withLanguage language: String) -> AwesomeMediaCaption? {
        for caption in captions where caption.language == language {
            return caption
        }
        
        return nil
    }
    
    public var defaultCaption: AwesomeMediaCaption? {
        for caption in captions where caption.isDefault {
            return caption
        }
        
        return captions.first
    }
    
    public var currentCaption: AwesomeMediaCaption? {
        set {
            if let url = url {
                UserDefaults.standard.set(newValue?.language, forKey: "\(url)-currentCaption")
            }
        }
        get {
            if let url = url, let language = UserDefaults.standard.string(forKey: "\(url)-currentCaption") {
                return caption(withLanguage: language)
            }
            
            return nil
        }
    }
    
}
