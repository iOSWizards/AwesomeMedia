//
//  MiniPlayerView.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 29/06/17.
//

import UIKit

fileprivate let miniPlayerHeight: CGFloat = 100

public enum MiniPlayerNotification: String {
    case miniPlayerFinished = "miniPlayerFinished"
    case miniPlayerShouldDismiss = "miniPlayerShouldDismiss"
}

enum MiniPlayerNotificationImage: String {
    case miniPlayerNotificationImageArrived = "miniPlayerNotificationImageArrived"
}

public class MiniPlayerView: UIView {
    
    @IBOutlet weak var coverPlaceholderImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var openMediaButton: UIButton!
    
    fileprivate var hideTimer: Timer?
    fileprivate var mediaUrlString: String?
    
    var openMediaCallback: (()->Void)?
    var saveMediaStateCallback: (()->Void)?
    var updateMediaCallback: (mediaUrl: String, title: String, coverImage: UIImage)?
    
    static func newInstance() -> MiniPlayerView{
        let podBundle = Bundle(for: AwesomeMedia.self)
        let bundleURL = podBundle.url(forResource: "AwesomeMedia", withExtension: "bundle")
        return Bundle(url: bundleURL!)!.loadNibNamed("MiniPlayerView", owner: self, options: nil)![0] as! MiniPlayerView
    }
    
    override public func awakeFromNib() {
        self.isHidden = true
        self.titleLabel.text = ""
        self.coverImageView.layer.masksToBounds = true
        
        addMediaStateObservers()
    }
    
    deinit {
        openMediaCallback = nil
        saveMediaStateCallback = nil
        updateMediaCallback = nil
        removeMediaStateObservers()
    }
    
    // MARK: - Animations
    
    func show(animated: Bool){
        self.isHidden = false
        if animated {
            self.awesomeMediaAnimateFadeInLeftToRight({
            })
        }else {
            self.alpha = 1
        }
        
        self.updateMediaView()
    }
    
    func hide(animated: Bool, andPause pause: Bool = true){
        self.titleLabel.text = ""
        
        if animated {
            self.awesomeMediaAnimateFadeOutRightToLeft({
                if pause {
                    self.playerDidEnd()
                }
            })
        }else{
            if pause {
                playerDidEnd()
            }
        }
    }
    
    func playerDidEnd(_ shouldPause: Bool = true) {
        self.saveMediaStateCallback?()
        AwesomeMedia.shared.seek(toTime: 0)
        if shouldPause {
            if AwesomeMedia.shared.playerIsPlaying {
                AwesomeMedia.shared.pause()
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MiniPlayerNotification.miniPlayerFinished.rawValue), object: nil)
        self.removeFromSuperview()
    }
    
    func shouldDismiss() {
        playerDidEnd(false)
    }
    
    func hideAnimated(){
        hide(animated: true)
    }
    
    // MARK: - Events
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        playButton.awesomeMediaAnimateTouchDown(halfWay: {
            if !AwesomeMedia.shared.playerIsPlaying {
                AwesomeMedia.shared.play()
            }else{
                AwesomeMedia.shared.pause()
                
                self.saveMediaStateCallback?()
            }
            
            self.updateMediaView()
        })
    }
    
    @IBAction func openMediaButtonPressed(_ sender: Any) {
        openMediaCallback?()
    }
    
    func updateMediaView(){
        let podBundle = Bundle(for: AwesomeMedia.self)
        self.playButton.setImage(AwesomeMedia.shared.playerIsPlaying ? UIImage(named: "awesomeMediaBtnPause", in: podBundle, compatibleWith: nil) : UIImage(named: "awesomeMediaBtnPlay", in: podBundle, compatibleWith: nil), for: .normal)
        
        //updates miniplayer info
        DispatchQueue.main.async {
            self.mediaUrlString = self.updateMediaCallback?.mediaUrl
            self.titleLabel.text = self.updateMediaCallback?.title
            self.coverImageView.image = self.updateMediaCallback?.coverImage
        }
        
        hideTimer?.invalidate()
        if !AwesomeMedia.shared.playerIsPlaying {
            //            hideTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hideAnimated), userInfo: nil, repeats: false)
        }
    }
    
    // MARK: - Pan Gestures
    
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    fileprivate var initialCenter = CGPoint(x: 0, y: 0)
    fileprivate var initialTouchPoint = CGPoint(x: 0, y: 0)
    fileprivate var lastDistanceFromTarget = CGPoint(x: 0, y: 0)
    fileprivate let distanceToClose: CGFloat = 100
    fileprivate let alphaAnimationTime: Double = 0.2
    
    @IBAction func panAction(_ rec: UIPanGestureRecognizer) {
        
        let point: CGPoint = rec.location(in: self.superview)
        let distance: CGPoint = CGPoint(x: point.x - initialTouchPoint.x, y: point.y - initialTouchPoint.y)
        let minX = (self.superview?.bounds.origin.x ?? 0)-UIScreen.main.bounds.width
        
        self.translatesAutoresizingMaskIntoConstraints = true
        
        switch rec.state {
        case .began:
            AwesomeMedia.shared.isPlayingLandscapeMedia = false
            initialCenter = self.center
            initialTouchPoint = point
            break
        case .changed:
            self.center.x = initialCenter.x + distance.x
            self.alpha = 1-(distance.x/UIScreen.main.bounds.width)
            if distance.x < 0 {
                self.alpha = 1-(distance.x * -1/UIScreen.main.bounds.width)
            }
            
            //avoid going any further than the initial position to the top
            if self.frame.origin.x < minX {
                self.frame.origin.x = minX
            }
            
            break
        case .ended:
            if rec.velocity(in: nil).x > 0 {
                self.awesomeMediaAnimateFadeOutLeftToRight({
                    self.playerDidEnd()
                })
            } else {
                self.hideAnimated()
            }
            break
        default:
            break
        }
    }
    
}

// MARK: - Media Observers

extension MiniPlayerView {
    
    func addMediaStateObservers(){
        //add observers for media state changes
        AwesomeMedia.addObserver(self, selector: #selector(MiniPlayerView.mediaStateChanged), event: .startedPlaying)
        AwesomeMedia.addObserver(self, selector: #selector(MiniPlayerView.mediaStateChanged), event: .pausedPlaying)
        AwesomeMedia.addObserver(self, selector: #selector(MiniPlayerView.mediaStateChanged), event: .stopedPlaying)
        AwesomeMedia.addObserver(self, selector: #selector(MiniPlayerView.mediaStateChanged), event: .finishedPlaying)
        AwesomeMedia.addObserver(self, selector: #selector(MiniPlayerView.mediaStateChanged), event: .failedPlaying)
        NotificationCenter.default.addObserver(self, selector: #selector(MiniPlayerView.shouldDismiss), name: NSNotification.Name(rawValue: MiniPlayerNotification.miniPlayerShouldDismiss.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MiniPlayerView.imageArrived(notification:)), name: NSNotification.Name(rawValue: MiniPlayerNotificationImage.miniPlayerNotificationImageArrived.rawValue), object: nil)
    }
    
    func removeMediaStateObservers(){
        AwesomeMedia.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    func mediaStateChanged(){
        updateMediaView()
    }
    
    public static func notifyWithImage(image: UIImage) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MiniPlayerNotificationImage.miniPlayerNotificationImageArrived.rawValue), object: nil, userInfo: ["image": image])
    }
    
    func imageArrived(notification: NSNotification) {
        if let image = notification.userInfo?["image"] as? UIImage {
            self.updateMediaCallback = (updateMediaCallback?.mediaUrl ?? "", updateMediaCallback?.title ?? "", image)
            mediaStateChanged()
        }
    }
    
    // MARK:- Get most actual view controller
    
    public static func getVisibleViewController(_ rootViewController: UIViewController? = nil) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    
}

extension UIView {
    
    public func showMiniPlayerViewIfNeeded(offsetFromBottom: CGFloat = 0, openCallBack: (()->Void)?, saveMediaStateCallBack: (()->Void)?, updateMediaCallback: (mediaUrl: String, title: String, coverImage: UIImage)?) {
        if AwesomeMedia.shared.playerIsPlaying {
            //mini player is only available for audio
            if AwesomeMedia.shared.isPlayingVideo {
                hideMiniPlayerView(animated: true)
                return
            }
            
            if let miniPlayer = visibleMiniPlayer {
                miniPlayer.frame = CGRect(x: 0, y: self.bounds.size.height-miniPlayerHeight, width: self.bounds.size.width, height: miniPlayerHeight)
                miniPlayer.show(animated: false)
                
                miniPlayer.openMediaCallback = openCallBack
                miniPlayer.saveMediaStateCallback = saveMediaStateCallBack
                miniPlayer.updateMediaCallback = updateMediaCallback
                miniPlayer.updateMediaView()
                return
            }
        }else {
            hideMiniPlayerView(animated: true)
            return
        }
        
        let miniPlayer = MiniPlayerView.newInstance()
        
        miniPlayer.openMediaCallback = openCallBack
        miniPlayer.saveMediaStateCallback = saveMediaStateCallBack
        miniPlayer.updateMediaCallback = updateMediaCallback
        
        miniPlayer.frame.size = CGSize(width: self.bounds.size.width, height: miniPlayerHeight)
        miniPlayer.frame.origin = CGPoint(x: 0, y: self.bounds.size.height-miniPlayerHeight)
        self.addSubview(miniPlayer)
        
        self.addConstraint(NSLayoutConstraint(item: miniPlayer, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: offsetFromBottom))
        self.addConstraint(NSLayoutConstraint(item: miniPlayer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: miniPlayer, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: miniPlayer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: miniPlayerHeight))
        
        miniPlayer.show(animated: true)
    }
    
    public func hideMiniPlayerView(animated: Bool = false, andPause pause: Bool = false){
        for subview in subviews{
            if let subview = subview as? MiniPlayerView {
                subview.hide(animated: animated, andPause: pause)
            }
        }
    }
    
    public var visibleMiniPlayer: MiniPlayerView?{
        for subview in subviews{
            if let subview = subview as? MiniPlayerView {
                return subview
            }
        }
        
        return nil
    }
    
    func hideMiniPlayerView(afterDelay delay: Double){
        Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(hideMiniPlayerView(animated:andPause:)), userInfo: nil, repeats: false)
    }
    
    // MARK:- Get most actual view controller
    
    public func getVisibleViewController(_ rootViewController: UIViewController? = nil) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    
}
