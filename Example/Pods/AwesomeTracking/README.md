# AwesomeTracking

[![CI Status](https://img.shields.io/travis/evandro@itsdayoff.com/AwesomeTracking.svg?style=flat)](https://travis-ci.org/evandro@itsdayoff.com/AwesomeTracking)
[![Version](https://img.shields.io/cocoapods/v/AwesomeTracking.svg?style=flat)](https://cocoapods.org/pods/AwesomeTracking)
[![License](https://img.shields.io/cocoapods/l/AwesomeTracking.svg?style=flat)](https://cocoapods.org/pods/AwesomeTracking)
[![Platform](https://img.shields.io/cocoapods/p/AwesomeTracking.svg?style=flat)](https://cocoapods.org/pods/AwesomeTracking)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 10 or Higher
- Swift 4

## Installation

AwesomePurchase is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AwesomeTracking', git: 'https://github.com/Mindvalley/Mobile_iOS_Library_AwesomeTracking', tag: '1.0.8'
```
## Usage

To set the environment you will need to use, `AwesomeTracking.setEnvironment(isDevelopment: false)`, by default the code on `Mindvalley` app has development sending to the staging environment and non-development build pointing to prodution.

To send events, you simply need to create a dictionary of type `[String: String]` with the properties (keys) you want to send and corresponding values. After that, jut call `trackV2` passing via parameter the event name, and `with: properties`.

### Usage Example:

```swift
let properties: [String: String] = [
 "asset id" : "1234",
 "day":"1",
 "quest id":"26",
 "quest name": "Superbrain",
 "cohort id": "1236" ,
 "product id": "345" ,
 "platform": "ios"
]

AwesomeTracking.trackV2("open day", with: properties)
```
If you only need to send the event name and the super properties already configured, simply use:

```swift
AwesomeTracking.trackV2("open day")
```

## License

AwesomeTracking is available under the MIT license. See the LICENSE file for more info.

