//
//  RestaurantListViewController.swift
//  Pizza Finder
//
//  Created by George on 12/09/2018.
//  Copyright © 2018 George Ashton. All rights reserved.
//

import UIKit
import Siesta

class RestaurantListViewController: UIViewController {

  static let locations = ["Brighton", "Liverpool", "London", "Manchester"]

  @IBOutlet weak var tableView: UITableView!

  private var restaurants: [Restaurant] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  private var statusOverlay = ResourceStatusOverlay()

  var currentLocation: String! {
    didSet {
      restaurantListResource = YelpAPI.sharedInstance.restaurantList(for: currentLocation)
    }
  }
  
  var restaurantListResource: Resource? {
    didSet {
      // Remove any existing observers
      oldValue?.removeObservers(ownedBy: self)
      
      // Add this VC as observer
      restaurantListResource?
        .addObserver(self)
        // Loading overlay
        .addObserver(statusOverlay, owner: self)
        // Load data for resource if needed (based on the cache expiration)
        .loadIfNeeded()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    currentLocation = RestaurantListViewController.locations[0]
    tableView.register(RestaurantListTableViewCell.nib, forCellReuseIdentifier: "RestaurantListTableViewCell")
    statusOverlay.embed(in: self)
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    statusOverlay.positionToCoverParent()
  }
}


// MARK: - UITableViewDataSource
extension RestaurantListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return restaurants.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantListTableViewCell",
                                             for: indexPath) as! RestaurantListTableViewCell

    guard indexPath.row <= restaurants.count else {
      return cell
    }

    let restaurant = restaurants[indexPath.row]
    cell.nameLabel.text = restaurant.name
    cell.iconImageView.imageURL = restaurant.imageUrl
    return cell
  }
}

// MARK: - UITableViewDelegate
extension RestaurantListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = RestaurantListTableViewHeader()
    headerView.delegate = self
    headerView.location = currentLocation
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.row <= restaurants.count else {
      return
    }
    
    let detailsViewController = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(withIdentifier: "RestaurantDetailsViewController")
      as! RestaurantDetailsViewController
    detailsViewController.restaurantId = restaurants[indexPath.row].id
    navigationController?.pushViewController(detailsViewController, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

// MARK: - RestaurantListTableViewHeaderDelegate
extension RestaurantListViewController: RestaurantListTableViewHeaderDelegate {
  func didTapHeaderButton(_ headerView: RestaurantListTableViewHeader) {
    let locationPicker = UIAlertController(title: "Select location", message: nil, preferredStyle: .actionSheet)
    for location in RestaurantListViewController.locations {
      locationPicker.addAction(UIAlertAction(title: location, style: .default) { [weak self] action in
        guard let `self` = self else { return }
        self.currentLocation = action.title
        self.tableView.reloadData()
      })
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    locationPicker.addAction(cancelAction)
    present(locationPicker, animated: true)
  }
}

// MARK: - ResourceObserver
extension RestaurantListViewController: ResourceObserver {
  func resourceChanged(_ resource: Resource, event: ResourceEvent) {
    restaurants = resource.typedContent() ?? []
  }
}
