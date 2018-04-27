//
//  AwesomeMediaDownloadManager.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/24/18.
//

import Foundation

public enum AwesomeMediaDownloadState {
    case downloading
    case downloaded
    case none
}

public class AwesomeMediaDownloadManager {
    
    public static func mediaDownloadState(withParams mediaParams: AwesomeMediaParams) -> AwesomeMediaDownloadState {
        guard let downloadUrl = AwesomeMediaManager.url(forParams: mediaParams) else {
            return .none
        }
        
        if downloadUrl.offlineFileExists {
            print("File \(downloadUrl) is offline")
            return .downloaded
        }
        
        return .none
    }
    
    public static func downloadMedia(withParams mediaParams: AwesomeMediaParams, completion:@escaping (Bool) -> Void){
        guard let downloadUrl = AwesomeMediaManager.url(forParams: mediaParams) else {
            completion(false)
            return
        }
        
        // to check if it exists before downloading it
        if downloadUrl.offlineFileExists {
            AwesomeMedia.log("The file already exists at path")
            completion(true)
        } else {
            URLSession.shared.downloadTask(with: downloadUrl, completionHandler: { (location, response, error) -> Void in
                guard let location = location , error == nil else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                
                location.moveOfflineFile(to: downloadUrl.offlineFileDestination, completion: { (success) in
                    DispatchQueue.main.async {
                        completion(success)
                    }
                })
            }).resume()
        }
    }
    
    public static func deleteDownloadedMedia(withParams mediaParams: AwesomeMediaParams, completion:@escaping (Bool) -> Void){
        guard let downloadUrl = AwesomeMediaManager.url(forParams: mediaParams) else {
            completion(false)
            return
        }
        
        downloadUrl.deleteOfflineFile(completion)
    }
}

extension UIViewController {
    
    public func confirmMediaDeletion(withParams mediaParams: AwesomeMediaParams, completion:@escaping (Bool) -> Void) {
        guard let downloadUrl = AwesomeMediaManager.url(forParams: mediaParams) else {
            completion(false)
            return
        }
        
        // we should delete the media.
        let alertController = UIAlertController(
            title: "availableoffline_delete_title".localized,
            message: "availableoffline_delete_message".localized,
            preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(
            title: "availableoffline_delete_button_confirm".localized,
            style: .destructive,
            handler: { (action) in
                downloadUrl.deleteOfflineFile(completion)
        }))
        
        alertController.addAction(UIAlertAction(title: "availableoffline_delete_button_cancel".localized, style: .cancel, handler: { (action) in
            
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}
