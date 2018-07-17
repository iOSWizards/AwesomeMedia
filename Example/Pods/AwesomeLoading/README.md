# AwesomeLoading

[![CI Status](http://img.shields.io/travis/evandro@itsdayoff.com/AwesomeLoading.svg?style=flat)](https://travis-ci.org/evandro@itsdayoff.com/AwesomeLoading)
[![Version](https://img.shields.io/cocoapods/v/AwesomeLoading.svg?style=flat)](http://cocoapods.org/pods/AwesomeLoading)
[![License](https://img.shields.io/cocoapods/l/AwesomeLoading.svg?style=flat)](http://cocoapods.org/pods/AwesomeLoading)
[![Platform](https://img.shields.io/cocoapods/p/AwesomeLoading.svg?style=flat)](http://cocoapods.org/pods/AwesomeLoading)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 9 or Higher
- Swift 4

## Installation

AwesomeLoading is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AwesomeLoading', git: 'https://github.com/iOSWizards/AwesomeLoading', tag: '0.1.5'
```
## Usage

Import AwesomeLoading to your class, from any UIView in the project:

**Start Custom Animation:** viewName.`startLoadingAnimation(json: "customLoadingJSONFileName")`

**Start Custom Animation from Separate Bundle:** viewName.`startLoadingAnimation(json: "customLoadingJSONFileName", bundle: Custom.bundle)`

**Start Default ActivityIndicator Animation:** viewName.`startLoadingAnimation()`

**Start (DELAYED) Custom Animation:** viewName.`startLoadingAnimationDelayed(delay: 3.0,json: "customLoadingJSONFileName", bundle: Custom.bundle)`

**Stop Animation:** viewName.`stopLoadingAnimation()`

### For default animations:

First:
**Default Json:** `AwesomeLoading.defaultAnimationJson = "beacon"`

**Default Bundle:** `AwesomeLoading.defaultAnimationBundle = Bundle.main`

**Default Size:** `AwesomeLoading.defaultAnimationSize = CGSize(width: 100, height: 100)`

Then:
**Default animation:** viewName.`startLoadingAnimation()`

## License

AwesomeLoading is available under the MIT license. See the LICENSE file for more info.

