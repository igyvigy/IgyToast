
import UIKit

final public class ConstraintsSettings {
  fileprivate(set) var left: CGFloat?
  fileprivate(set) var right: CGFloat?
  fileprivate(set) var top: CGFloat?
  fileprivate(set) var bottom: CGFloat?
  fileprivate(set) var centerX: CGFloat?
  fileprivate(set) var centerY: CGFloat?
  fileprivate(set) var width: CGFloat?
  fileprivate(set) var height: CGFloat?
  
  public static var zero: ConstraintsSettings { return ConstraintsSettings(edgeInsets: .zero) }
  
  public init(left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, centerX: CGFloat? = nil, centerY: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) {
    self.left = left
    self.right = right
    self.centerX = centerX
    self.centerY = centerY
    self.top = top
    self.bottom = bottom
    self.width = width
    self.height = height
  }
  
  public init(left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
    self.left = left
    self.right = right
    self.top = top
    self.bottom = bottom
  }
  
  public init(edgeInsets: UIEdgeInsets = .zero) {
    self.left = edgeInsets.left
    self.right = edgeInsets.right
    self.top = edgeInsets.top
    self.bottom = edgeInsets.bottom
  }
  
  public init(centerX: CGFloat, centerY: CGFloat, width: CGFloat?, height: CGFloat?) {
    self.centerX = centerX
    self.centerY = centerY
    self.width = width
    self.height = height
  }
  
  public init(centerX: CGFloat, top: CGFloat?, bottom: CGFloat?, width: CGFloat?) {
    self.centerX = centerX
    self.top = top
    self.bottom = bottom
    self.width = width
  }
  
  public init(centerX: CGFloat, top: CGFloat?, left: CGFloat?, right: CGFloat?, height: CGFloat?) {
    self.centerX = centerX
    self.top = top
    self.left = left
    self.right = right
    self.height = height
  }
  
  public init(centerY: CGFloat, left: CGFloat?, right: CGFloat?, height: CGFloat?) {
    self.centerY = centerY
    self.left = left
    self.right = right
    self.height = height
  }
  
  public init(width: CGFloat?, height: CGFloat?, left: CGFloat?, right: CGFloat?, top: CGFloat?, bottom: CGFloat?) {
//    assert(left == nil || right == nil || width == nil, "ambigious constraints")
//    assert(top == nil || bottom == nil || height == nil, "ambigious constraints")
    
    self.left = left
    self.right = right
    self.top = top
    self.bottom = bottom
    self.width = width
    self.height = height
  }
}

extension UIView {
  public func addSubview(_ subview: UIView, with constraintsSettings: ConstraintsSettings) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    addSubview(subview)
    let dict = ["v": subview]
    
    if let bottom = constraintsSettings.bottom {
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v]-" + "(\(bottom))" + "-|", options: [], metrics: nil, views: dict))
      
    }
    
    if let top = constraintsSettings.top {
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-" + "(\(top))" + "-[v]", options: [], metrics: nil, views: dict))
    }
    
    if let right = constraintsSettings.right {
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v]-" + "(\(right))" + "-|", options: [], metrics: nil, views: dict))
      
    }
    
    if let left = constraintsSettings.left {
      addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-" + "(\(left))" + "-[v]", options: [], metrics: nil, views: dict))
    }
    
    if let height = constraintsSettings.height {
      addConstraint(NSLayoutConstraint(item: subview, attribute: .height,
                                       relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                       multiplier: 1, constant: height))
    }
    
    if let width = constraintsSettings.width {
      addConstraint(NSLayoutConstraint(item: subview, attribute: .width,
                                       relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                       multiplier: 1, constant: width))
    }
    
    if let centerY = constraintsSettings.centerY {
      addConstraint(NSLayoutConstraint(item: subview, attribute: .centerY,
                                       relatedBy: .equal, toItem: self, attribute: .centerY,
                                       multiplier: 1, constant: centerY))
    }
    
    if let centerX = constraintsSettings.centerX {
      addConstraint(NSLayoutConstraint(item: subview, attribute: .centerX,
                                       relatedBy: .equal, toItem: self, attribute: .centerX,
                                       multiplier: 1, constant: centerX))
    }
  }
}
