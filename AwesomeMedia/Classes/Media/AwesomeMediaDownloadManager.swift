//
//  AwesomeMediaDownloadManager.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/24/18.
//

import Foundation

public typealias ProgressCallback = (Float) -> ()
public typealias DownloadedCallback = (Bool) -> ()

public enum AwesomeMediaDownloadState {
    case downloading
    case downloaded
    case none
}

public class AwesomeMediaDownloadManager: NSObject {
    
    // public shared
    public static var shared = AwesomeMediaDownloadManager()
    
    // Private variables
    fileprivate var session: URLSession?
    fileprivate var downloadTask: URLSessionDownloadTask?
    fileprivate var downloadUrl: URL?
    
    // Callbacks
    public var progressCallback: ProgressCallback?
    public var downloadedCallback: DownloadedCallback?
    
    public static func mediaDownloadState(withParams mediaParams: AwesomeMediaParams) -> AwesomeMediaDownloadState {
        guard let downloadUrl = mediaParams.url?.url else {
            return .none
        }
        
        if downloadUrl.offlineFileExists {
            print("File \(downloadUrl) is offline")
            return .downloaded
        }
        
        return .none
    }
    
    public static func downloadMedia(withParams mediaParams: AwesomeMediaParams, completion: @escaping DownloadedCallback, progressUpdated: @escaping ProgressCallback){
        guard let downloadUrl = mediaParams.url?.url else {
            completion(false)
            return
        }
        
        // to check if it exists before downloading it
        if downloadUrl.offlineFileExists {
            AwesomeMedia.log("The file already exists at path")
            completion(true)
        } else {
            shared.progressCallback = progressUpdated
            shared.downloadedCallback = completion
            shared.startDownloadSession(withUrl: downloadUrl)
        }
    }
    
    public static func deleteDownloadedMedia(withParams mediaParams: AwesomeMediaParams, completion:@escaping (Bool) -> Void){
        guard let downloadUrl = mediaParams.url?.url else {
            completion(false)
            return
        }
        
        downloadUrl.deleteOfflineFile(completion)
    }
}

extension AwesomeMediaDownloadManager {
    
    fileprivate func startDownloadSession(withUrl url: URL) {
        downloadUrl = url
        
        let configuration = URLSessionConfiguration.default
        //let queue = NSOperationQueue.mainQueue()
        
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        downloadTask = session?.downloadTask(with: url)
        downloadTask?.resume()
    }
    
    fileprivate func finishDownloadSession() {
        session?.finishTasksAndInvalidate()
        session = nil
        downloadTask?.cancel()
        downloadTask = nil
    }
    
}

extension AwesomeMediaDownloadManager: URLSessionDelegate, URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        finishDownloadSession()
        
        guard let downloadUrl = downloadUrl else {
            return
        }
        
        location.moveOfflineFile(to: downloadUrl.offlineFileDestination, completion: { (success) in
            DispatchQueue.main.async {
                self.downloadedCallback?(success)
            }
        })
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.progressCallback?(progress)
        }
    }
    
}

extension UIViewController {
    
    public func confirmMediaDeletion(withParams mediaParams: AwesomeMediaParams, fromView: UIView? = nil, completion:@escaping (Bool) -> Void) {
        guard let downloadUrl = mediaParams.url else {
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
                downloadUrl.url?.deleteOfflineFile { (success) in
                    DispatchQueue.main.async {
                        completion(success)
                    }
                }
        }))
        
        alertController.addAction(UIAlertAction(title: "availableoffline_delete_button_cancel".localized, style: .cancel, handler: { (action) in
            
        }))
        
        if let fromView = fromView {
            alertController.popoverPresentationController?.sourceView = fromView
            alertController.popoverPresentationController?.sourceRect = fromView.bounds
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
