
import Foundation

public extension CGRect {
  var center: CGPoint {
    return CGPoint(x: origin.x + width / 2, y: origin.y + height / 2)
  }
  
  var bounds: CGRect {
    return CGRect(origin: .zero, size: size)
  }

  init(center: CGPoint, size: CGSize) {
    self.init(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
  }
}
