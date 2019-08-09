
import UIKit

extension CALayer {
  public func addBorder(width: CGFloat, color: UIColor, cornerRadius: CGFloat = 0) {
    roundCorner(radius: cornerRadius)
    
    borderColor = color.cgColor
    borderWidth = width
  }
  
  public func roundCorner(radius: CGFloat) {
    cornerRadius = radius
    masksToBounds = true
  }
  
  public func toCirle() {
    roundCorner(radius: bounds.height / 2)
  }
  
  public func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = opacity
    shadowOffset = offSet
    shadowRadius = radius
    
    shadowPath = UIBezierPath(rect: self.bounds).cgPath
  }
  
  public func animateCornerRadius(to value: CGFloat, with duration: TimeInterval) {
    let animation = CABasicAnimation(keyPath: #keyPath(cornerRadius))
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    animation.fromValue = cornerRadius
    animation.toValue = Float(value)
    animation.duration = duration
    add(animation, forKey: #keyPath(cornerRadius))
    cornerRadius = value
  }
  
  public func animateOpacity(to value: CGFloat, with duration: TimeInterval) {
    let animation = CABasicAnimation(keyPath: #keyPath(opacity))
    animation.fromValue = opacity
    animation.toValue = Float(value)
    animation.duration = duration
    add(animation, forKey: #keyPath(opacity))
    opacity = Float(value)
  }
}
