# CMBottomGestureView

[![CI Status](https://img.shields.io/travis/CMJunghoon/CMBottomGestureView.svg?style=flat)](https://travis-ci.org/CMJunghoon/CMBottomGestureView)
[![Version](https://img.shields.io/cocoapods/v/CMBottomGestureView.svg?style=flat)](https://cocoapods.org/pods/CMBottomGestureView)
[![License](https://img.shields.io/cocoapods/l/CMBottomGestureView.svg?style=flat)](https://cocoapods.org/pods/CMBottomGestureView)
[![Platform](https://img.shields.io/cocoapods/p/CMBottomGestureView.svg?style=flat)](https://cocoapods.org/pods/CMBottomGestureView)

## Preview
![image](https://github.com/CMJunghoon/CMBottomGestureView/blob/master/Demo/CMBottomGestureView_Demo.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CMBottomGestureView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CMBottomGestureView'
```

## Use

```swift
let bottom = CMBottomGestureView(presentedView: view,
                                     maxHeight: 500,
                                     minHeight: 200,
                                 swipeDownType: .stayBottom)
view.addSubview(bottom)
```

## Author

CMJunghoon, cjh@renomedia.co.kr

## License

CMBottomGestureView is available under the MIT license. See the LICENSE file for more info.
