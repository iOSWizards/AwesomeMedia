# AwesomeMedia

[![Version](https://img.shields.io/cocoapods/v/AwesomeMedia.svg?style=flat)](http://cocoapods.org/pods/AwesomeMedia)
[![License](https://img.shields.io/cocoapods/l/AwesomeMedia.svg?style=flat)](http://cocoapods.org/pods/AwesomeMedia)
[![Platform](https://img.shields.io/cocoapods/p/AwesomeMedia.svg?style=flat)](http://cocoapods.org/pods/AwesomeMedia)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 10 or Higher
- Swift 4

## Installation

AwesomeMedia is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AwesomeMedia", git: 'https://github.com/iOSWizards/AwesomeMedia.git', tag: '1.5'
```

## Usage

1. Create a `var` extending `AwesomeMediaView`. Or extend a `UIView` component from the storyboard.
```swift
var mediaView: AwesomeMediaView!
```

2. Setup media to play.
```swift
mediaView.setup(mediaPath: "http://overmind2.mindvalleyacademy.com/api/v1/assets/267bb3c6-d042-40ea-b1bd-9c9325c413eb.m3u8")
```

3. Assign player layer to self (in case playing video).
```swift
mediaView.addPlayerLayer()
```

4. Setup delegate.
```swift
AwesomeMedia.shared.playerDelegate = self

extension MediaViewController: AwesomeMediaPlayerDelegate {
    public func didChangeSpeed(to: Float, mediaType: AMMediaType) {
        print("MediaViewController didChangeSpeed(\(to))")
    }

    public func didChangeSlider(to: Float, mediaType: AMMediaType) {
        print("MediaViewController didChangeSlider(\(to))")
    }

    public func didStopPlaying(mediaType: AMMediaType) {
        print("MediaViewController didStopPlaying")
    }

    public func didStartPlaying(mediaType: AMMediaType) {
        print("MediaViewController didStartPlaying")
    }

    public func didPausePlaying(mediaType: AMMediaType) {
        print("MediaViewController didPausePlaying")
    }

    public func didFinishPlaying(mediaType: AMMediaType) {
        print("FullscreenMediaViewController didFinishPlaying")
    }

    public func didFailPlaying(mediaType: AMMediaType) {
        print("FullscreenMediaViewController didFailPlaying")
    }
}
```

5. Setup orientation listener.
```swift
AwesomeMedia.shared.addOrientationObserverGoingLandscape(observer: self, selector: #selector(MediaViewController.goToLandscapeController))

func goToLandscapeController() {
    performSegue(withIdentifier: "presentFullScreenSegue", sender: self)
}
```

6. Print Logs.
```swift
AwesomeMedia.showLogs = true
```

## License

AwesomeMedia is available under the MIT license. See the LICENSE file for more info.
