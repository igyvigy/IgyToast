
import UIKit

@available(iOS 9.0, *)
extension UIStackView {
  // MARK: - toggle stackView
  /**
   Method wich hide/show views in StackView depends on indices. Default value for _:isAnimated = true
   - Parameter indices: Array of Ints.
   - Parameter isHidden: Should be hidden or showed.
   - Parameter animated: Default value = false
   */
  public func setHidden(_ indices: [Int], isHidden: Bool, animated: Bool = false, completion: (() -> Void)? = nil) {
    guard !animated else {
      UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
        self.configureViews(for: indices, isHidden: isHidden)
      }) { _ in
        completion?()
      }
      return
    }
    configureViews(for: indices, isHidden: isHidden)
    completion?()
  }
  
  public func hide(_ indices: [Int], animated: Bool = false, completion: (() -> Void)? = nil) {
    setHidden(indices, isHidden: true, animated: animated, completion: completion)
  }
  
  public func show(_ indices: [Int], animated: Bool = false, completion: (() -> Void)? = nil) {
    setHidden(indices, isHidden: false, animated: animated, completion: completion)
  }
  
  public func configureViews(for indices: [Int], isHidden: Bool, animated: Bool = true, completion: @escaping () -> Void) {
    guard !animated else {
      UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
        self.configureViews(for: indices, isHidden: isHidden)
      }) { _ in
        completion()
      }
      return
    }
    configureViews(for: indices, isHidden: isHidden)
    completion()
  }
  
  private func configureViews(for indices: [Int], isHidden: Bool) {
    indices.forEach({
      self.arrangedSubviews[safe: $0]?.isHidden = self.arrangedSubviews[$0].isHidden == isHidden ? self.arrangedSubviews[safe: $0]?.isHidden ?? false : isHidden
    })
    indices.forEach({ self.arrangedSubviews[safe: $0]?.alpha = isHidden ? 0 : 1 })
  }
}
