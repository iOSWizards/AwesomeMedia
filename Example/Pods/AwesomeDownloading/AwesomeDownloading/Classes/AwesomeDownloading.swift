//
//  AwesomeDownloading.swift
//  AwesomeDownloading
//
//  Created by Emmanuel on 10/06/2018.
//

import Foundation
import UIKit

public typealias ProgressCallback = (Float) -> ()
public typealias DownloadedCallback = (Bool) -> ()

public enum AwesomeMediaDownloadState {
    case downloading
    case downloaded
    case none
}

public class AwesomeDownloading: NSObject {
    
    // public shared
    public static var shared = AwesomeDownloading()
    
    // Private variables
    fileprivate var session: URLSession?
    fileprivate var downloadTask: URLSessionDownloadTask?
    fileprivate var downloadUrl: URL?
    
    // Callbacks
    public var progressCallback: ProgressCallback?
    public var downloadedCallback: DownloadedCallback?
    
    public static func mediaDownloadState(withUrl url: URL?) -> AwesomeMediaDownloadState {
        guard let downloadUrl = url else {
            return .none
        }
        
        if downloadUrl.offlineFileExists {
            print("File \(downloadUrl) is offline")
            return .downloaded
        }
        
        return .none
    }
    
    public static func downloadMedia(withUrl url: URL?, completion: @escaping DownloadedCallback, progressUpdated: @escaping ProgressCallback){
        guard let downloadUrl = url else {
            completion(false)
            return
        }
        
        // to check if it exists before downloading it
        if downloadUrl.offlineFileExists {
            print("The file already exists at path")
            completion(true)
        } else {
            shared.progressCallback = progressUpdated
            shared.downloadedCallback = completion
            shared.startDownloadSession(withUrl: downloadUrl)
        }
    }
    
    public static func deleteDownloadedMedia(withUrl url: URL?, completion:@escaping (Bool) -> Void){
        guard let downloadUrl = url else {
            completion(false)
            return
        }
        
        downloadUrl.deleteOfflineFile(completion)
    }
    
}

extension AwesomeDownloading {
    
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

extension AwesomeDownloading: URLSessionDelegate, URLSessionDownloadDelegate {
    
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
    
    public func confirmMediaDeletion(withUrl url: URL?, fromView: UIView? = nil, withTitle title: String, withMessage message: String, withConfirmButtonTitle confirmButtonTitle:String, withCancelButtonTitle cancelButtonTitle:String, completion:@escaping (Bool) -> Void) {
        guard let downloadUrl = url else {
            completion(false)
            return
        }
        
        // we should delete the media.
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(
            title: confirmButtonTitle,
            style: .destructive,
            handler: { (action) in
                downloadUrl.deleteOfflineFile { (success) in
                    DispatchQueue.main.async {
                        completion(success)
                    }
                }
        }))
        
        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (action) in
        
        }))
    
        if let fromView = fromView {
            alertController.popoverPresentationController?.sourceView = fromView
            alertController.popoverPresentationController?.sourceRect = fromView.bounds
        }
    
        present(alertController, animated: true, completion: nil)
    }
}
