//
//  FileLoader.swift
//  AwesomeLoading
//
//  Created by Emmanuel on 12/07/2018.
//

import Foundation

public class FileLoader {
    
    public static var shared = FileLoader()
    
    public func loadJSONFrom(file: String?, fromBundle: Bundle? = nil) -> Any? {
        let bundle = fromBundle ?? Bundle.main
        if let path = bundle.path(forResource: file, ofType: "json") {
            do {
                let jsonData = try? NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    return try! JSONSerialization.jsonObject(
                        with: jsonData! as Data,
                        options: JSONSerialization.ReadingOptions.mutableContainers
                        )
                }
            }
        }
        return nil
    }
}
