# BitmovinAnalyticsCollector

[![Version](https://img.shields.io/cocoapods/v/BitmovinAnalyticsCollector.svg?style=flat)](http://cocoapods.org/pods/BitmovinAnalyticsCollector)
[![License](https://img.shields.io/cocoapods/l/BitmovinAnalyticsCollector.svg?style=flat)](http://cocoapods.org/pods/BitmovinAnalyticsCollector)
[![Platform](https://img.shields.io/cocoapods/p/BitmovinAnalyticsCollector.svg?style=flat)](http://cocoapods.org/pods/BitmovinAnalyticsCollector)

## Example


The following example creates a BitmovinAnalytics object and attaches an AVPlayer instance to it. 

```swift
// Create a BitmovinAnalyticsConfig using your Bitmovin analytics license key and/or your Bitmovin Player Key
let config:BitmovinAnalyticsConfig = BitmovinAnalyticsConfig(key:"YOUR_ANALYTICS_KEY",playerKey:"YOUR_PLAYER_KEY")
let config:BitmovinAnalyticsConfig = BitmovinAnalyticsConfig(key:"YOUR_ANALYTICS_KEY")

// Create a BitmovinAnalytics object using the config just created 
analyticsCollector = BitmovinAnalytics(config: config);

// Attach your player instance
analyticsCollector.attachAVPlayer(player: player);

// Detach your player when you are done. 
analyticsCollector.detachPlayer()
```


#### Optional Configuration Parameters
```swift
config.cdnProvider = .akamai
config.customData1 = "customData1"
config.customData2 = "customData2"
config.customData3 = "customData3"
config.customData4 = "customData4"
config.customData5 = "customData5"
config.customerUserId = "customUserId"
config.experimentName = "experiement-1"
config.videoId = "iOSHLSStatic"
config.path = "/vod/breadcrumb/"
```

A [full example app]() can be seen in the github repo 

## Requirements

## Installation

BitmovinAnalyticsCollector is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BitmovinAnalyticsCollector'
```

Then, in your command line run 

```ruby
pod install
```

## Author

Cory Zachman, cory.zachman@bitmovin.com

## License

BitmovinAnalyticsCollector is available under the MIT license. See the LICENSE file for more info.