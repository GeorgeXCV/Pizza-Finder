//
//  YelpAPI.swift
//  Pizza Finder
//
//  Created by George on 12/09/2018.
//  Copyright © 2018 George Ashton. All rights reserved.
//

import Foundation
import Siesta

class YelpAPI {
  
  static let sharedInstance = YelpAPI()
  
  //Yelp API url = Service
 private let service = Service(baseURL: "https://api.yelp.com/v3", standardTransformers: [.text, .image])
  
  private init() {
    // Details that will log to console
    LogCategory.enabled = [.network, .pipeline, .observers]

      // API Token
      service.configure("**") {
        $0.headers["Authorization"] =
        "Bearer B6sOjKGis75zALWPa7d2dNiNzIefNbLGGoF75oANINOL80AUhB1DjzmaNzbpzF-b55X-nG2RUgSylwcr_UYZdAQNvimDsFqkkhmvzk6P8Qj0yXOQXmMWgTD_G7ksWnYx"
         // Results expire after 1 hour
        $0.expirationTime = 60 * 60
      }
      
      let jsonDecoder = JSONDecoder()
      
      service.configureTransformer("/businesses/*") {
        try jsonDecoder.decode(RestaurantDetails.self, from: $0.content)
      }
      
      service.configureTransformer("/businesses/search") {
        try jsonDecoder.decode(SearchResults<Restaurant>.self, from: $0.content).businesses
      }
    }
  
  // Fetch list of pizza restaurants at given location 
  func restaurantList(for location: String) -> Resource {
    return service
      .resource("/businesses/search")
      .withParam("term", "pizza")
      .withParam("location", location)
  }
  
  func restaurantDetails(_ id: String) -> Resource {
    return service
      .resource("/businesses")
      .child(id)
  }
 }
