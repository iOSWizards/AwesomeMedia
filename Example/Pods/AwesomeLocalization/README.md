# AwesomeLocalization

[![Version](https://img.shields.io/cocoapods/v/AwesomeLocalization.svg?style=flat)](http://cocoapods.org/pods/AwesomeLocalization)
[![License](https://img.shields.io/cocoapods/l/AwesomeLocalization.svg?style=flat)](http://cocoapods.org/pods/AwesomeLocalization)
[![Platform](https://img.shields.io/cocoapods/p/AwesomeLocalization.svg?style=flat)](http://cocoapods.org/pods/AwesomeLocalization)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 9.0 or Higher
- Swift 4

## Installation

AwesomeLocalization is a public pod, only available through the address below.

```ruby
pod 'AwesomeLocalization', git: 'https://github.com/iOSWizards/AwesomeLocalization.git', tag: '0.2.1'
```

## Usage

1. Add the file `Localizable.strings` to the project
<br />![alt text](https://github.com/iOSWizards/AwesomeLocalization/blob/master/Images/LocalizableStrings.png)

2. Add `localization placeholder`s to `Localizable` file
<br />![alt text](https://github.com/iOSWizards/AwesomeLocalization/blob/master/Images/LocalizableStringsPlaceholders.png)

3. In the `Storyboard`, select the `component` you want to localize, add `localization placeholder` to `Localized Text` field.
<br />![alt text](https://github.com/iOSWizards/AwesomeLocalization/blob/master/Images/StoryboardLocalization.png)

4. Run the project

## Available Fields

1. `Localized Text`: Placeholder for localization.
2. `Custom Localization File`: Name of localization file (if not Localizable.strings)
3. `is Attributed`: Toggles on/off attributed strings for HTML formatting.

## UIKit support

Currently, AwesomeLocalization supports localization for:
- UIButton
- UILabel
- UITextField
- UINavigationItem
- UIBarItem

## License

AwesomeLocalization is available under the MIT license. See the LICENSE file for more info.
