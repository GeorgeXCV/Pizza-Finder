//
//  Restaurant.swift
//  Pizza Finder
//
//  Created by George on 12/09/2018.
//  Copyright © 2018 George Ashton. All rights reserved.
//

import Foundation

struct Restaurant: Codable {
  let id: String
  let name: String
  let imageUrl: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case imageUrl = "image_url"
  }
}

struct SearchResults<T: Decodable>: Decodable {
  let businesses: [T]
}
