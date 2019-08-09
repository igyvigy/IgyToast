<H1 align="center">
IgyToast 🦎🍞
</H1>
<H4 align="center">
<br> safe area-aware 🤹‍ iPhone X-ready 📲 keyboard-handling ⌨️ rotation-compatible 🔄</br>
</H4>



<p align="center">
<a href="https://cocoapods.org/pods/IgyToast"><img alt="Version" src="https://img.shields.io/cocoapods/v/IgyToast.svg?style=flat"></a> 
<a href="https://github.com/igyvigy/IgyToast/blob/master/LICENSE"><img alt="Liscence" src="https://img.shields.io/cocoapods/l/IgyToast.svg?style=flat"></a> 
<a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-iOS-green.svg"/></a> 
<a href="https://developer.apple.com/swift"><img alt="Swift4.2" src="https://img.shields.io/badge/language-Swift4.2-orange.svg"/></a>

## Usage

### Basic usage
import module:
```swift
import IgyToast
```
create your custom view from code and set it's height constraint so IgyToast knows it's vertical boundary:

```swift
lazy var customView: UIView = {
    let view = UIView(frame: .zero)
    view.backgroundColor = .green
    let label = UILabel(frame: .zero)
    label.text = "Custom view"
    label.textAlignment = .center
    label.center = view.center
    view.addSubview(label, with: IgyToast.ConstraintsSettings(edgeInsets: .zero))
    label.heightAnchor.constraint(equalToConstant: 100).isActive = true
    return view
  }()
```

now show toast with:
```swift
Toast.current.showToast(customView)
```
<img width="400" alt="IgyToast" src="https://github.com/igyvigy/IgyToast/blob/master/IgyToast.gif">

Alternatively, use views created from XIB or Storyboard, who's height is already constrained:
```swift
Toast.current.showToast(customViewFromXIB)
```
in case if Toast contents height changes:
```swift
Toast.current.toastVC?.layoutVertically()
```
to hide programmatically:
```swift
Toast.current.hideToast()
```
...or		
 ```swift		
 Toast.current.hideToast {		
     //called after hide animation finished		
 }		
 ```

### Advanced usage

In case IgyToast's content is higher than screen available height - IgyToast's content becomes scrollable vertically.

You can optionally provide a view as `Header` or/and as a `Footer` - those wouldn't be a part of scrolling content.

```swift
let title: UILabel = .makeZero()
title.font = .systemFont(ofSize: 24, weight: .heavy)
title.text = "Title"
let titleContainer: UIView = .makeZero()
titleContainer.addSubview(title, with: .init(left: 16, right: 16, top: 8, bottom: 20))
    
let field: UITextField = .makeZero()
field.placeholder = "tap me"
let fieldContainer: UIView = .makeZero()
fieldContainer.addSubview(field, with: .init(left: 16, right: 16, top: 16, bottom: 16))
    
let imageView = UIImageView(image: #imageLiteral(resourceName: "toast"))
imageView.contentMode = .scaleAspectFit
imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
let stack = UIStackView(arrangedSubviews: [fieldContainer, imageView])
stack.axis = .vertical
    
Toast.current.showToast(stack, header: titleContainer)
```
<img width="400" alt="IgyToast" src="https://github.com/igyvigy/IgyToast/blob/master/IgyToast.gif">

## Installation

### Cocoapods

IgyToast is on Cocoapods! After [setting up Cocoapods in your project](https://guides.cocoapods.org/using/getting-started.html), simply add the folowing to your Podfile:
```
pod 'IgyToast'
```
then run `pod install` 

## Example usage

<p align="center">
For example project please check <a href="https://github.com/igyvigy/IgyToast/tree/master/IgyToastExamples">This one</a>
</p>

## Extra

IgyToast includes class `ConstraintsSettings` which contains convenience methods for adding constraints from code, thanks to [sssbohdan](https://github.com/sssbohdan) 😎

### Requirements

- Swift 4.2+
- iOS 11.0+

### Contributing

Pull requests, feature requests and bug reports are welcome 

