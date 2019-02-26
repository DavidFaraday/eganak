//
//  Location.swift
//  WeatherApp
//
//  Created by David Kababyan on 03/01/2019.
//  Copyright © 2019 David Kababyan. All rights reserved.
//

import Foundation

struct WeatherLocation: Codable, Equatable {
    var city: String!
    var country: String!
    var countryCode: String!
    var isCurrentLocation: Bool!
}
