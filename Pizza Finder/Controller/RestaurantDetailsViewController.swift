//
//  RestaurantDetailsViewController.swift
//  Pizza Finder
//
//  Created by George on 12/09/2018.
//  Copyright © 2018 George Ashton. All rights reserved.
//

import UIKit
import Cosmos
import Siesta

class RestaurantDetailsViewController: UIViewController {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingView: CosmosView!
  @IBOutlet weak var reviewLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var imageView1: RemoteImageView!
  @IBOutlet weak var imageView2: RemoteImageView!
  @IBOutlet weak var imageView3: RemoteImageView!

  var restaurantId: String!
  private var restaurantDetail: RestaurantDetails? {
    didSet {
      if let restaurant = restaurantDetail {
        nameLabel.text = restaurant.name
        ratingView.settings.fillMode = .precise
        ratingView.rating = Double(restaurant.rating)
        reviewLabel.text = String(describing: restaurant.reviewCount) + " reviews"
        priceLabel.text = restaurant.price
        phoneLabel.text = restaurant.displayPhone
        addressLabel.text = restaurant.location.displayAddress.joined(separator: "\n")
        if restaurant.photos.count > 0 {
          imageView1.imageURL = restaurant.photos[0]
        }
        if restaurant.photos.count > 1 {
          imageView2.imageURL = restaurant.photos[1]
        }
        if restaurant.photos.count > 2 {
          imageView3.imageURL = restaurant.photos[2]
        }
      }
    }
  }
  
  // Setup status overlay
  private var statusOverlay = ResourceStatusOverlay()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Request restaurant details for a given restaurantId
    YelpAPI.sharedInstance.restaurantDetails(restaurantId)
      .addObserver(self)
      .addObserver(statusOverlay, owner: self)
      .loadIfNeeded()
    
    
    statusOverlay.embed(in: self)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    statusOverlay.positionToCoverParent()
  }

}

// MARK: - ResourceObserver
extension RestaurantDetailsViewController: ResourceObserver {
  func resourceChanged(_ resource: Resource, event: ResourceEvent) {
    restaurantDetail = resource.typedContent() ?? nil
  }
}
