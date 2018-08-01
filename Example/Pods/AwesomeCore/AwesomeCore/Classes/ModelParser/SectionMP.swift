//
//  SectionMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 10/07/17.
//

import Foundation

public struct SectionMP {
    
    private init() {
        
    }
    
    /// Parses an JSON object to the model Marker, in case the json object:
    /// has no _title_ or _time_ or _courseChapterSectionMarkerId_ it returns nil.
    ///
    /// - Parameters:
    ///   - jsonObject: JSON object to be parsed.
    ///   - parseSuccess: Marker object with its properties populated.
    public static func parseSectionFrom(jsonObject: [String: AnyObject]) -> Section? {
        
        var array: [Marker] = []
        if let jsonArray = jsonObject["markers"] as? [[String: AnyObject]] {
            for object in jsonArray {
                if let marker = MarkerMP.parseMarkerFrom(jsonObject: object) {
                    array.append(marker)
                }
            }
        }
        
        let section = Section(
            courseChapterSectionId: AwesomeCoreParser.intValue(jsonObject, key: "id"),
            title: ParserCoreHelper.parseString(jsonObject, key: "title"),
            type: ParserCoreHelper.parseString(jsonObject, key: "type"),
            markers: array,
            position: AwesomeCoreParser.intValue(jsonObject, key: "position"),
            body: ParserCoreHelper.parseString(jsonObject, key: "body").cleanHTMLAC,
            mode: ParserCoreHelper.parseString(jsonObject, key: "mode"),
            duration: AwesomeCoreParser.intValue(jsonObject, key: "duration"),
            continueAtTime: 0,
            downloadable: AwesomeCoreParser.boolValue(jsonObject, key: "downloadable"),
            embedCode: ParserCoreHelper.parseString(jsonObject, key: "embed_code"),
            imageLink: ParserCoreHelper.parseString(jsonObject, key: "image_link"),
            assetCoverUrl: ParserCoreHelper.parseString(jsonObject, key: "asset_cover_url"),
            assetUrl: ParserCoreHelper.parseString(jsonObject, key: "asset_url"),
            assetSize: AwesomeCoreParser.intValue(jsonObject, key: "asset_size"),
            assetFileExtension: ParserCoreHelper.parseString(jsonObject, key: "asset_file_extension"),
            assetStreamingUrl: ParserCoreHelper.parseString(jsonObject, key: "asset_streaming_url"),
            assetId: ParserCoreHelper.parseInt(jsonObject, key: "asset_id").intValue
        )
        
        return section
    }
    
}
