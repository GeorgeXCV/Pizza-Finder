//
//  RestaurantListTableViewHeader.swift
//  Pizza Finder
//
//  Created by George on 12/09/2018.
//  Copyright © 2018 George Ashton. All rights reserved.
//

import UIKit

@objc protocol RestaurantListTableViewHeaderDelegate {
  func didTapHeaderButton(_ headerView: RestaurantListTableViewHeader)
}

class RestaurantListTableViewHeader: UIView {
  @IBOutlet var view: UIView!
  @IBOutlet weak var locationButton: UIButton!

  var location: String? {
    didSet {
      locationButton.setTitle(location, for: .normal)
    }
  }

  weak var delegate: RestaurantListTableViewHeaderDelegate?

  init() {
    super.init(frame: CGRect())
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  func commonInit() {
    view = Bundle.main.loadNibNamed("RestaurantListTableViewHeader", owner: self, options: nil)?.first as! UIView
    view.frame = bounds
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOpacity = 1
    layer.shadowRadius = 1
    layer.masksToBounds = false
    addSubview(view)
  }

  @IBAction func changeButtonTapped(_ sender: Any) {
    delegate?.didTapHeaderButton(self)
  }
}
