//
//  CustomViewFromXIB.swift
//  IgyToastExamples
//
//  Created by Andrii on 8/9/19.
//  Copyright © 2019 io.igyvigy. All rights reserved.
//

import UIKit
import MapKit

class CustomViewFromXIB: UIView {
  
  @IBOutlet weak var view: UIView!
  @IBOutlet weak var mapView: MKMapView!
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    nibSetup()
  }
  
  required public init?(coder aDecoder: NSCoder) {
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
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
    let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
    
    return nibView
  }
  
  
}
