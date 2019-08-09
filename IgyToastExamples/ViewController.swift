//
//  ViewController.swift
//  IgyToastExamples
//
//  Created by Andrii on 8/9/19.
//  Copyright © 2019 io.igyvigy. All rights reserved.
//

import UIKit
import IgyToast

class ViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  lazy var customView: UIView = {
    let view = UIView(frame: .zero)
    view.backgroundColor = .green
    let label = UILabel(frame: .zero)
    label.text = "Custom view"
    label.textAlignment = .center
    label.center = view.center
    view.addSubview(label, with: ConstraintsSettings(edgeInsets: .zero))
    label.heightAnchor.constraint(equalToConstant: 100).isActive = true
    return view
  }()
  
  
  
  @IBAction func showCustomViewToast(_ sender: Any) {
    Toast.current.showToast(customView)
  }
  
  lazy var customViewFromXIB: CustomViewFromXIB = {
    return CustomViewFromXIB(frame: .zero)
  }()
  
  @IBAction func showCustomViewFromXibToast(_ sender: Any) {
    Toast.current.showToast(customViewFromXIB)
  }
}

