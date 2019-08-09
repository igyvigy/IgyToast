
import UIKit

protocol CKToastViewDelegate: class {
  func toastViewDidClose(_ toastView: CKToastView)
}

final class CKToastView: NibLoadingView {
  
  static var availableHeight: CGFloat {
    let window = UIApplication.shared.keyWindow!
    let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    let topInset = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    return window.bounds.height - topInset - bottomInset - 40
  }
  
  enum AnimationDirection: Int {
    case up, down, undefined//, left, right, undefined
  }
  
  @IBOutlet weak var holderView: UIView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var footerView: UIView!
  
  @IBOutlet weak var titleView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var outterStackView: UIStackView!
  @IBOutlet weak var titleViewHolder: UIView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var bottomSafeView: UIView!
  
  @IBOutlet weak var stackHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var keyboardAwareKonstraint: NSLayoutConstraint!
  
  weak var delegate: CKToastViewDelegate?
  
  enum State {
    case expanded, collapsed
  }
  
  var currentTitleView: UIView? {
    return titleViewHolder.subviews.first
  }
  
  var currentContentView: UIView? {
    return stackView.arrangedSubviews.first
  }
  
  var keyboardHeight: CGFloat = 0
  var additionalSpaceValue: CGFloat = 0
  
  var runningAnimators = [UIViewPropertyAnimator](){
    didSet {
      if runningAnimators.count == 0 {
        self.allAnimatorsFinished(oldValue.last)
      }
    }
  }
  var isVisibleOnScreen: Bool {
    return bottomConstraint.constant <= 0
  }
  
  var animatorProgressMap = [UIViewPropertyAnimator?: CGFloat]()
  var state: State = .collapsed
  var blurEffectView: UIVisualEffectView?
  var panner: UIPanGestureRecognizer!
  var tapper: UITapGestureRecognizer!
  var bottomConstraint: NSLayoutConstraint!
  var parentView: UIView!
  
  var title: String?
  var headerView: UIView?
  
  private var justReversed = false

  override internal func becomeFirstResponder() -> Bool {
    contentView.subviews.forEach { $0.becomeFirstResponder() }
    return true
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    holderView.roundCorner(radius: 2)
    contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  func configure(_ subview: UIView, blurView: UIVisualEffectView, bottomConstraint: NSLayoutConstraint, parentView: UIView, title: String? = nil, headerView: UIView? = nil, footerView: UIView? = nil) {
    blurEffectView = blurView
    self.parentView = parentView
    self.bottomConstraint = bottomConstraint
    tapper = UITapGestureRecognizer(target: self, action: #selector(handleTap(tapper:)))
    panner = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panner:)))
    panner.isEnabled = false
    blurView.addGestureRecognizer(tapper)
    parentView.addGestureRecognizer(panner)
    titleLabel.text = title
    if let headerView = headerView { setTitleView(headerView) }
    
    stackView.addArrangedSubview(subview)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    layoutVertically()
    isHidden = true
    
    if let fV = footerView {
      self.footerView.addSubview(fV, with: .zero)
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  func setTitleView(_ view: UIView, cs: ConstraintsSettings? = nil) {
    titleViewHolder.subviews.forEach { $0.removeFromSuperview() }
    let css = cs ?? ConstraintsSettings(left: 0, right: 0, top: 0, bottom: 0)
    titleViewHolder.addSubview(view, with: css)
    headerView = view
  }
  
  func layoutVertically() {
    layoutVertically(title: nil, headerView: nil)
  }
  
  func layoutVertically(for title: String?) {
    layoutVertically(title: title, headerView: nil)
  }
  
  func layoutVertically(for view: UIView?) {
    layoutVertically(title: nil, headerView: view)
  }
  
  private func layoutVertically(title: String?, headerView: UIView?) {
    enum HeaderMode { case title, headerView, none }
    if let title = title {
      self.title = title
    }
    if let headerView = headerView {
      self.headerView = headerView
    }
    var mode: HeaderMode {
      if self.title != nil {
        return .title
      }
      if self.headerView != nil {
        return .headerView
      }
      if title != nil && headerView == nil {
        return .title
      }
      if title == nil && headerView != nil {
        return .headerView
      }
      if title == nil && headerView == nil {
        return .none
      }
      
      return .none
    }
    
    stackView.layoutSubviews()
    titleView.layoutSubviews()
    titleViewHolder?.layoutSubviews()
  
    var availableSpace = CKToastView.availableHeight - keyboardHeight
    
    if keyboardHeight > 0 {
      availableSpace -= (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
    }
    var height: CGFloat
    
    switch mode {
    case .title:
      outterStackView.configureViews(for: [0], isHidden: false, animated: false, completion: {})
      outterStackView.configureViews(for: [1], isHidden: true, animated: false, completion: {})
      outterStackView.layoutSubviews()
      let titleSizeHeight = titleView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
      let contentSizeHeight = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
      height = contentSizeHeight + titleSizeHeight
      
    case .headerView:
      outterStackView.configureViews(for: [0], isHidden: true, animated: false, completion: {})
      outterStackView.configureViews(for: [1], isHidden: false, animated: false, completion: {})
      outterStackView.layoutSubviews()
      let headerViewSizeHeight = titleViewHolder?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height ?? 0
      let contentSizeHeight = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
      height = contentSizeHeight + headerViewSizeHeight
      
    case .none:
      outterStackView.configureViews(for: [0,1], isHidden: true, animated: false, completion: {})
      outterStackView.layoutSubviews()
      let contentSizeHeight = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
      height = contentSizeHeight
    }

    if stackHeightConstraint != nil {
      stackHeightConstraint.constant = min(height, availableSpace)
    }
  }
  
  func insert(_ subview: UIView, at: Int) {  stackView.insertArrangedSubview(subview, at: at) }
  func add(_ subview: UIView) { stackView.addArrangedSubview(view) }
  
  var keyboardAnimator: UIViewPropertyAnimator? {
    didSet {
      if keyboardAnimator == nil {
        self.layoutVertically()
      }
    }
  }
  
  func changeKeyboardHeight(_ newHeight: CGFloat, duration: TimeInterval) {
    self.keyboardAwareKonstraint.constant = newHeight - additionalSpaceValue
    let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) { [weak self] in
      self?.parentView.layoutIfNeeded()
    }
    animator.addCompletion { [weak self] position in
      if position == .end || position == .start {
        self?.layoutVertically()
      }
    }
    animator.startAnimation()
  }
  
  @objc func handleTap(tapper: UITapGestureRecognizer) {
    toggle(duration: 0.5)
  }
  
  @objc func handlePan(panner: UIPanGestureRecognizer) {
    let translation = panner.translation(in: self)
    let velocity = panner.velocity(in: view)
    
    switch panner.state {
    case .began:
      if case .up = directionFromVelocity(velocity) {
        if state == .expanded { return }
      } else if case .down = directionFromVelocity(velocity) {
        if state == .collapsed { return }
      }
      animateTransitionIfNeeded(duration: 0.5, pauseInsteadOfStarting: true)
    case .changed:
      let translatedY: CGFloat = translation.y
      var progress: CGFloat = 0
      switch state {
      case .collapsed:
        progress = (-translatedY / (frame.bounds.height))
      case .expanded:
        progress = (translatedY / (frame.bounds.height))
      }
      progress = max(0.001, min(0.999, progress));
      updateInteractiveTransition(fractionComplete: progress)
    case .ended:
      let translatedY: CGFloat = translation.y
      var progress: CGFloat = 0
      switch state {
      case .collapsed:
        progress = (-translatedY / (frame.bounds.height - self.keyboardHeight))
      case .expanded:
        progress = (translatedY / (frame.bounds.height - self.keyboardHeight))
      }
      for animator in runningAnimators {
        if progress < 0.4 && !isVelocityFastEnoughAndInSameDirection(velocity) {
          reverse(animator, duration: 0.5)
          return
        }
        animator.continueAnimation(withTimingParameters: animator.timingParameters, durationFactor: 1)
      }
    default: break
    }
  }
  
  private func isVelocityFastEnoughAndInSameDirection(_ velocity: CGPoint) -> Bool {
    let direction = directionFromVelocity(velocity)
    let isDirectionSame: Bool = {
      switch direction {
      case .up:
        if state == .expanded && velocity.y < 0 { return false }
        return velocity.y < 0
      case .down:
        if state == .collapsed && velocity.y > 0 { return false }
        return velocity.y > 0
      default:
        return false
      }
    }()
    return abs(velocity.y) > 100 && isDirectionSame
  }
  
  private func reverse(_ animator: UIViewPropertyAnimator, duration: TimeInterval) {
    let fraction = animator.fractionComplete
    animator.pauseAnimation()
    self.justReversed = true
    self.remove(animator)
    self.toggle(duration: duration)
    self.runningAnimators.forEach { $0.fractionComplete = fraction }
  }
  
  private func allAnimatorsFinished(_ lastAnimator: UIViewPropertyAnimator?) {
    if isVisibleOnScreen  {
      state = .expanded
    } else  {
      state = .collapsed
      if !justReversed {
        blurEffectView?.isHidden = true
        panner.isEnabled = false
        endEditing(false)
        isHidden = true
        delegate?.toastViewDidClose(self)
      } else { justReversed = false }
    }
    if justReversed { justReversed = false }
    if keyboardHeight > 0 {
      changeKeyboardHeight(keyboardHeight, duration: 0.25)
    }
  }
  
  func animateTransitionIfNeeded(duration: TimeInterval, pauseInsteadOfStarting: Bool = false) {
    if isHidden { isHidden = false }
    if runningAnimators.isEmpty {
      let animator = UIViewPropertyAnimator(duration: duration, timingParameters: UISpringTimingParameters(dampingRatio: 1.0))
      animator.addAnimations { [weak self] in
        switch self?.state {
        case .collapsed?:
          self?.contentView.layer.cornerRadius = 20
          self?.bottomConstraint.constant = 0
          self?.blurEffectView?.isHidden = false
          self?.panner.isEnabled = true
          self?.blurEffectView?.effect = UIBlurEffect(style: .dark)
          self?.parentView.layoutIfNeeded()
        case .expanded?:
          self?.bottomConstraint.constant = self?.view.frame.height ?? 0
          self?.contentView.layer.cornerRadius = 0
          self?.blurEffectView?.effect = nil
          self?.parentView.layoutIfNeeded()
        case .none:
          break
        }
      }
      animator.addCompletion { [weak self] (position: UIViewAnimatingPosition) in
        if position == .end || position == .start {
          self?.remove(animator)
        }
      }
      runningAnimators.append(animator)
    }
    runningAnimators.forEach { animator in
      if pauseInsteadOfStarting {
        animator.pauseAnimation()
        animatorProgressMap[animator] = animator.fractionComplete
      } else {
        animator.startAnimation()
      }
    }
  }
  
  func toggle(duration: TimeInterval) {
    if runningAnimators.isEmpty {
      animateTransitionIfNeeded(duration: duration)
    }
  }
  
  func updateInteractiveTransition(fractionComplete: CGFloat) {
    runningAnimators.forEach { animator in
      let progress = animatorProgressMap[animator]
      animator.fractionComplete = fractionComplete + (progress ?? 0)
    }
  }
  
  private func remove(_ animator: UIViewPropertyAnimator) {
    runningAnimators.remove(animator)
    animatorProgressMap[animator] = nil
  }
  
  private func directionFromVelocity(_ velocity: CGPoint) -> AnimationDirection {
    guard velocity != .zero else { return .undefined }
    var derivedDirection: AnimationDirection = .undefined
    derivedDirection = velocity.y < 0 ? .up : .down
    return derivedDirection
  }
  
  @objc func keyboardWillChangeFrame(notification: NSNotification) {
    guard let keyboardBeginFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
    guard let keyboardEndFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
    
    let beginHeight = UIScreen.main.bounds.height - keyboardBeginFrame.origin.y
    let endHeight = UIScreen.main.bounds.height - keyboardEndFrame.origin.y
    
    keyboardHeight =  endHeight > 0 ? endHeight - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) : endHeight

    if (beginHeight == 0 || endHeight == 0) && state != .expanded {
    } else {
      if endHeight != 0 && isVisibleOnScreen {
        changeKeyboardHeight(keyboardHeight, duration: 0.25)
      } else if isVisibleOnScreen && state == .expanded {
        //case when toast view is visible
        changeKeyboardHeight(keyboardHeight, duration: 0.25)
      }
    }
  }
}

