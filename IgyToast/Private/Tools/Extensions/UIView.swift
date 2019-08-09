
import UIKit

extension UIView {
   func addBorder(width: CGFloat, color: UIColor, cornerRadius: CGFloat = 0) {
    layer.addBorder(width: width, color: color, cornerRadius: cornerRadius)
  }
  
   func roundCorner(radius: CGFloat) {
    layer.roundCorner(radius: radius)
  }
  
   func animateCornerRadius(to value: CGFloat, with interval: TimeInterval) {
    layer.animateCornerRadius(to: value, with: interval)
  }
  
   func toCirle() {
    layer.roundCorner(radius: bounds.height / 2)
    clipsToBounds = true
  }
  
  public var compressedSize: CGSize {
    return systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
  }
  
  public class func makeZero<V: UIView>() -> V {
    let v = V(frame: .zero)
    return v
  }
}
