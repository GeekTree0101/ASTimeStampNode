# ASTimeStampNode

[![CI Status](https://img.shields.io/travis/Geektree0101/ASTimeStampNode.svg?style=flat)](https://travis-ci.org/Geektree0101/ASTimeStampNode)
[![Version](https://img.shields.io/cocoapods/v/ASTimeStampNode.svg?style=flat)](https://cocoapods.org/pods/ASTimeStampNode)
[![License](https://img.shields.io/cocoapods/l/ASTimeStampNode.svg?style=flat)](https://cocoapods.org/pods/ASTimeStampNode)
[![Platform](https://img.shields.io/cocoapods/p/ASTimeStampNode.svg?style=flat)](https://cocoapods.org/pods/ASTimeStampNode)

# This Repo will release with Texture 2.8

<img src="https://github.com/GeekTree0101/ASTimeStampNode/blob/master/res/banner.jpg" />
<img src="https://github.com/GeekTree0101/ASTimeStampNode/blob/master/res/example.gif" />

## Example

```swift
class ASTimeStampScreenNodeController: ASViewController<ASControlNode> {
    
    let attr: [NSAttributedStringKey: Any] =
        [.font: UIFont.systemFont(ofSize: 60.0, weight: .medium),
         .foregroundColor: UIColor.init(red: 1.0 / 255, green: 232 / 255, blue: 201 / 255, alpha: 1.0)]
    
    lazy var timerNode: ASTimeStampNode = {
        let node = ASTimeStampNode(startAt: Date(),
                                   format: .hourMinSec,
                                   flowDirection: .decrease)
        node.updateAttributes(attr, animated: false)
        node.start()
        return node
    }()
    
    init() {
        super.init(node: .init())
        self.node.automaticallyManagesSubnodes = true
        self.node.backgroundColor = .white
        self.node.layoutSpecBlock = { (_, _) -> ASLayoutSpec in
            return ASCenterLayoutSpec.init(centeringOptions: .XY, sizingOptions: [], child: self.timerNode)
        }
        self.node.addTarget(self, action: #selector(toggle), forControlEvents: .touchUpInside)
    }
    
    @objc func toggle() {
        self.timerNode.toggle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

## Requirements
iOS, ~> 9.x 

## Installation

ASTimeStampNode is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ASTimeStampNode'
```

## Author

Geektree0101, h2s1880@gmail.com

## License

ASTimeStampNode is available under the MIT license. See the LICENSE file for more info.
