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
    view.addSubview(label, with: IgyToast.ConstraintsSettings(edgeInsets: .zero))
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
  
  @IBAction func showViewWithHeader(_ sender: Any) {
    
    let title: UILabel = .makeZero()
    title.font = .systemFont(ofSize: 24, weight: .heavy)
    title.text = "Title"
    let titleContainer: UIView = .makeZero()
    titleContainer.addSubview(title, with: .init(left: 16, right: 16, top: 8, bottom: 20))
    
    let field: UITextField = .makeZero()
    field.placeholder = "tap me"
    let fieldContainer: UIView = .makeZero()
    fieldContainer.addSubview(field, with: .init(left: 16, right: 16, top: 16, bottom: 16))
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "toast"))
    imageView.contentMode = .scaleAspectFit
    imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
    let stack = UIStackView(arrangedSubviews: [fieldContainer, imageView])
    stack.axis = .vertical
    
    Toast.current.showToast(stack, header: titleContainer)
  }
}

