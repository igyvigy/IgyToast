//
//  Toast.swift
//  IgyToast
//
//  Created by Andrii on 8/9/19.
//  Copyright © 2019 io.igyvigy. All rights reserved.
//

import Foundation

public final class Toast: NSObject {
  public static let current = Toast()
  private override init () {}
  
  var toastQueue: [(toast: UIView, header: UIView?)] = []
  var toastHideCompletion: (() -> Void)?
  var isShowingToastVC: ((Bool) -> Void)?
  
  public var toastVC: ToastVC? {
    didSet {
      if toastVC == nil {
        if let nextToast = toastQueue.first {
          showToast(nextToast.toast, header: nextToast.header)
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
  func showToast(_ view: UIView, header: UIView? = nil, footer: UIView? = nil) {
    isShowingToastVC?(true)
    
    if let _ = toastVC {
      hideToast() { [unowned self] in
        self.show(view, header: header, footer: footer)
      }
    } else {
      show(view, header: header, footer: footer)
    }
  }
  
  func hideToast(_ completion: (() -> Void)? = nil) {
    if let toastVC = toastVC {
      toastHideCompletion = completion
      toastVC.toast?.hide()
    } else {
      completion?()
    }
  }
}

private extension Toast {
  func show(_ view: UIView, header: UIView? = nil, footer: UIView? = nil) {
    let vc: UIViewController? = {
      if let nav = pvc() as? UINavigationController {
        return nav.viewControllers.first
      } else if let toastVC = pvc() as? ToastVC {
        return toastVC.presentingViewController
        //        toastVC
      } else {
        return pvc()
      }
    }()
    let tvc = ToastVC.make(view, header: header, footer: footer)
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
}
