
import UIKit

extension UIView {
  public func addBorder(width: CGFloat, color: UIColor, cornerRadius: CGFloat = 0) {
    layer.addBorder(width: width, color: color, cornerRadius: cornerRadius)
  }
  
  public func roundCorner(radius: CGFloat) {
    layer.roundCorner(radius: radius)
  }
  
  public func animateCornerRadius(to value: CGFloat, with interval: TimeInterval) {
    layer.animateCornerRadius(to: value, with: interval)
  }
  
  public func toCirle() {
    layer.roundCorner(radius: bounds.height / 2)
    clipsToBounds = true
  }
  
  public func createAndConfigureSubview(_ view: UIView?) {
    guard let view = view else { return }
    
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.translatesAutoresizingMaskIntoConstraints = true
    view.frame = frame
    addSubview(view)
  }
  
  public func roundCorners(_ corners: UIRectCorner, radius: CGSize) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radius)
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
  
  public func getSubviews<T: UIView>() -> [T] {
    var subviews = [T]()
    
    for subview in self.subviews {
      subviews += subview.getSubviews() as [T]
      
      if let subview = subview as? T {
        subviews.append(subview)
      }
    }
    
    return subviews
  }
  
  public func allSuperViews() -> [UIView] {
    guard let superview = self.superview else { return [] }
    
    return [superview] + (self.superview?.allSuperViews() ?? [])
  }
  
  public func getSuperview<T: UIView>() -> T? {
    guard self.superview != nil else { return nil }
    if let casted = superview as? T {
      return casted
    } else {
      return superview?.getSuperview()
    }
  }
  
  
  public func addGradient(with colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
    let gradeintLayer = CAGradientLayer()
    gradeintLayer.colors = colors.map { $0.cgColor }
    gradeintLayer.startPoint = startPoint
    gradeintLayer.endPoint = endPoint
    
    layer.insertSublayer(gradeintLayer, at: 0)
  }
  
  public static func createCircleOverlay(frame: CGRect,
                                         color: UIColor,
                                         alpha: CGFloat,
                                         center: CGPoint,
                                         radius: CGFloat) -> UIView {
    let overlayView = UIView(frame: frame)
    overlayView.backgroundColor = color
    overlayView.alpha = alpha
    let path = CGMutablePath()
    path.addArc(center: CGPoint(x: center.x, y: center.y),
                radius: radius,
                startAngle: 0.0,
                endAngle: 2.0 * .pi,
                clockwise: false)
    path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
    let maskLayer = CAShapeLayer()
    maskLayer.backgroundColor = UIColor.black.cgColor
    maskLayer.path = path
    maskLayer.fillRule = .evenOdd
    overlayView.layer.mask = maskLayer
    overlayView.clipsToBounds = true
    
    return overlayView
  }
  
  public var compressedSize: CGSize {
    return systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
  }
  
  public class func makeZero<V: UIView>() -> V {
    let v = V(frame: .zero)
    return v
  }
}
