
import Foundation

public final class Toast: NSObject {
  public static let current = Toast()
  private override init () {}
  
  private var toastQueue: [(toast: UIView, header: UIView?)] = []
  private var toastHideCompletion: (() -> Void)?
  private var isShowingToastVC: ((Bool) -> Void)?
  /**
   The closure will be triggered when the user taps on a clear view or will swipe down to close toast.
  */
  public var willBeClosedByUserInterection: (() -> Void)?
  
  public var toastVC: ToastVC? {
    didSet {
      if toastVC == nil {
        if let nextToast = toastQueue.first {
          show(nextToast.toast, header: nextToast.header)
          toastQueue.removeFirst()
        }
        if let _ = toastHideCompletion {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.toastHideCompletion?()
            self?.toastHideCompletion = nil
          }
        }
      }
    }
  }
}

public extension Toast {
  // MARK: - create and show new toast
  /**
   - Parameter view: view used as content for toast. Toast will calculate content height, based on vertival conctraints
   - Parameter header: optional header view. Header is not a part of vertically scrolling content and allways stays on top
   - Parameter footer: optional footer view. Footer is not a part of vertically scrolling content and allways stays on the bootom
   - Parameter backgroundColor: optional background color. By default background color is white.
   */
  func show(_ view: UIView, header: UIView? = nil, footer: UIView? = nil, backgroundColor: UIColor? = nil) {
    isShowingToastVC?(true)
    
    if let _ = toastVC {
      hide() { [unowned self] in
        self.showToast(view, header: header, footer: footer, backgroundColor: backgroundColor)
      }
    } else {
      showToast(view, header: header, footer: footer, backgroundColor: backgroundColor)
    }
  }
  
  // MARK: - hide current toast
  /**
   used to recalculate the height of toast's content
   - Parameter completion: called after toast finished animating
   */
  func hide(_ completion: (() -> Void)? = nil) {
    if let toastVC = toastVC {
      toastHideCompletion = completion
      toastVC.toast?.hide()
    } else {
      completion?()
    }
  }
  
  // MARK: - calculate content height
  /**
   used to recalculate height of tost's content
   */
  func layoutVertically() {
    toastVC?.layoutVertically()
  }
  
  // MARK: - get toast's content view
  /**
   that is the view, passed when presenting a toast
   */
  func getCurrentContentView() -> UIView? {
    return toastVC?.getCurrentContentView()
  }
  
  // MARK: - get toast's header view
  /**
   that is the view, passed as `header` when presenting a toast
   */
  func getCurrentHeaderView() -> UIView? {
    return toastVC?.getCurrentHeaderView()
  }
  
  // MARK: - toggle toast
  /**
   hide current toast if visible, show if not.
   - Parameter duration: Duration of animation. `Default` for `show` = 0.5, for `hide` = 0.25
   */
  func toggle(duration: TimeInterval) {
    toastVC?.toggle(duration: duration)
  }
}

private extension Toast {
  func showToast(_ view: UIView, header: UIView? = nil, footer: UIView? = nil, backgroundColor: UIColor? = nil) {
    let vc: UIViewController? = {
      if let nav = pvc() as? UINavigationController {
        return nav.viewControllers.first
      } else if let toastVC = pvc() as? ToastVC {
        return toastVC.presentingViewController
      } else {
        return pvc()
      }
    }()
    let tvc = ToastVC.make(view, header: header, footer: footer, backgroundColor: backgroundColor)
    vc?.present(tvc, animated: false, completion: nil)
    tvc.toast?.view?.delegate = self
    self.toastVC = tvc
  }
  
  func pvc() -> UIViewController? {
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      return topController
    } else {
      return nil
    }
  }
}

extension Toast: CKToastViewDelegate {
  func toastViewDidClose(_ toastView: CKToastView) {
    isShowingToastVC?(false)
    self.toastVC?.dismiss(animated: false, completion: nil)
    self.toastVC = nil
  }
  
  func toastViewWillBeClosedByUserIterection() {
    willBeClosedByUserInterection?()
  }
}
