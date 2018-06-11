//
//  URLExtensions.swift
//  AwesomeDownloading
//
//  Created by Emmanuel on 10/06/2018.
//

import Foundation

extension URL {
    public var offlineFileDestination: URL {
        let documentsDirectoryURL =  FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectoryURL.appendingPathComponent(lastPathComponent)
    }
    
    public var offlineFileName: String {
        return lastPathComponent
    }
    
    public var offlineFileExists: Bool {
        return FileManager().fileExists(atPath: offlineFileDestination.path)
    }
    
    public var offlineURLIfAvailable: URL {
        if offlineFileExists {
            return offlineFileDestination
        }
        return self
    }
    
    public func deleteOfflineFile(_ completion:@escaping (Bool) -> Void) {
        guard offlineFileExists else {
            completion(true)
            return
        }
        
        do {
            try FileManager().removeItem(at: offlineFileDestination)
            completion(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    public func moveOfflineFile(to: URL, completion:@escaping (Bool) -> Void) {
        do {
            try FileManager().moveItem(at: self, to: to)
            print("File moved to documents folder")
            completion(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(false)
        }
    }
}
