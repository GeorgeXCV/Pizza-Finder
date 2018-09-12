//
//  ResaurantListTableViewcell.swift
//  Pizza Finder
//
//  Created by George on 12/09/2018.
//  Copyright © 2018 George Ashton. All rights reserved.
//

import UIKit
import Siesta

class RestaurantListTableViewCell: UITableViewCell {

  static let nib = UINib(nibName: "RestaurantListTableViewCell", bundle: nil)

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var iconImageView: RemoteImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    iconImageView.layer.cornerRadius = 2
    iconImageView.layer.masksToBounds = true
  }
}
