# SVPinCodeView

Customizable view to imput pin-code for iOS application. Supported auto-filling from sms

## Swift 5.0;  >= iOS 11 


## Installation

PinCodeView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SVPinCodeView'
```
## How to use:

Just put UIView in your xib or storyboard and change class name on "SVPinCodeView" 

Use  @IBInspectable properties to change interface:

```ruby

pinCodeView.numberOfSymbols  = 4
pinCodeView.imputViewColor  = UIColor.init(red: 244/255.0, green: 245/255.0, blue: 247/255.0, alpha: 1)
pinCodeView.symbolColor  = UIColor.init(red: 255/255.0, green: 168/255.0, blue: 18/255.0, alpha: 1)
pinCodeView.underlineColor = UIColor = UIColor.init(red: 123/255.0, green: 207/255.0, blue: 218/255.0, alpha: 1)
pinCodeView.underlineSize = CGFloat = 3
pinCodeView.corners =  9
pinCodeView.font = UIFont.boldSystemFont(ofSize: 16)
pinCodeView.symbolSize  = 16
pinCodeView.code  = ""
pinCodeView.deegate = self
```

Implement PinCodeViewDelegate to detect imput code

## Author

Vitaly Singleton

## License

PinCodeView is available under the MIT license. See the LICENSE file for more info.
