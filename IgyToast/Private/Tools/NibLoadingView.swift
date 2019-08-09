
import Foundation

@IBDesignable
class NibLoadingView: UIView {
  
  @IBOutlet public weak var view: UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    nibSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    nibSetup()
  }
  
  private func nibSetup() {
    backgroundColor = .clear
    
    view = loadViewFromNib()
    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.translatesAutoresizingMaskIntoConstraints = true
    
    addSubview(view)
  }
  
  private func loadViewFromNib() -> UIView {
    let bundle = Bundle(for: CKToastView.self)
//    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
    let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
    
    return nibView
  }
  
  
}
