
import UIKit

protocol ToastVCDelegate: class {
  func shake()
}

public final class ToastVC: UIViewController {

  @IBOutlet weak var button: UIButton!
  
  var toast: ToastBuilder?
  weak var delegate: ToastVCDelegate?
  var grantFirstResponder: Bool = false
  
  static func make(_ view: UIView, header: UIView? = nil, grantFirstResponder: Bool = false, footer: UIView? = nil) -> ToastVC {
    let toastVC = ToastVC(view, header: header, grantFirstResponder: grantFirstResponder, footer: footer)
    toastVC.modalPresentationStyle = .overCurrentContext
    return toastVC
  }
  
  init(_ view: UIView, header: UIView? = nil, grantFirstResponder: Bool = false, footer: UIView? = nil) {
    let bundle = Bundle(for: CKToastView.self)
    super.init(nibName: "ToastVC", bundle: bundle)
    self.grantFirstResponder = grantFirstResponder
    self.toast = ToastBuilder.make(on: self, view: view, header: header, footer: footer)
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    view.isOpaque = false
    //this button prevents toast vc from being stack on screen with hidden toast
    button.addTarget(self, action: #selector(onViewTap), for: UIControl.Event.touchDown)
  }
  
  @objc func onViewTap() {
    if toast?.isShowing == false {
      dismiss(animated: false, completion: nil)
    }
  }
  
  deinit {
    print("☠️", String(describing: self))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func viewDidAppear(_ animated: Bool) {
    super .viewDidAppear(animated)
    self.toast?.show(grantFirstResponder: grantFirstResponder)
  }
  
  override public var canResignFirstResponder: Bool {
    return true
  }
  
  override public func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      delegate?.shake()
    }
  }
  
  func layoutVertically() {
    toast?.view?.layoutVertically()
  }
  
  func getCurrentContentView() -> UIView? {
    return toast?.view?.currentContentView
  }
  
  func getCurrentHeaderView() -> UIView? {
    return toast?.view?.currentTitleView
  }
  
  func toggle(duration: TimeInterval) {
    toast?.view?.toggle(duration: duration)
  }
}
