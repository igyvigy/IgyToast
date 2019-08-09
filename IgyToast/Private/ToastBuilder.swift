//
//  ToastBuilder.swift
//  ContactKeeper
//
//  Created by Andrii on 1/25/19.
//  Copyright © 2019 ROLIQUE. All rights reserved.
//

import UIKit

final class ToastBuilder {
  
  var isShowing: Bool = false
  var view: CKToastView?
  var blurView: UIVisualEffectView
  weak var vc: UIViewController?
  
  class func make(on vc: UIViewController, view: UIView, header: UIView? = nil, footer: UIView? = nil) -> ToastBuilder {
    let toast = ToastBuilder()
    toast.vc = vc
    toast.view = toast.makeView(view, header: header, footer: footer)
    
    return toast
  }
  
  init() {
    self.blurView = UIVisualEffectView(effect: nil)
    self.blurView.isHidden = true
  }
  
  private func makeView(_ view: UIView, header: UIView? = nil, footer: UIView? = nil) -> CKToastView? {
    guard let vc = vc else { return nil }
    let toastView = CKToastView(frame: .zero)
    toastView.translatesAutoresizingMaskIntoConstraints = false
    vc.view.addSubview(toastView)
    let leadingConstraint = toastView.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor)
    let trailingConstraint = toastView.trailingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor)
    let bottomCnstraint = toastView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor, constant: 1000)
    NSLayoutConstraint.activate([bottomCnstraint, leadingConstraint, trailingConstraint])
    let constraintSettings = ConstraintsSettings(left: 0, right: 0, top: 0, bottom: 0)
    vc.view.addSubview(blurView, with: constraintSettings)
    toastView.configure(view, blurView: blurView, bottomConstraint: bottomCnstraint, parentView: vc.view, title: nil, headerView: header, footerView: footer)
    return toastView
  }
  
  func replaceView(_ view: UIView, header: UIView? = nil) {
    self.view?.removeFromSuperview()
    self.view = nil
    self.view = makeView(view, header: header)
  }
  
  func show(grantFirstResponder: Bool = false) {
    if isShowing { hide() } else { isShowing = true }
    if let tv = self.view {
      vc?.view.bringSubviewToFront(tv)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      if grantFirstResponder {
        _ = self?.view?.becomeFirstResponder()
      }
      self?.view?.toggle(duration: 0.5)
    }
  }
  
  func hide(_ completion: (() -> Void)? = nil) {
    view?.toggle(duration: 0.25)
    isShowing = false
  }
  
}

