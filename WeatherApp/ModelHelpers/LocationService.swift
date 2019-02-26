//
//  LocationService.swift
//  WeatherApp
//
//  Created by David Kababyan on 06/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import Foundation


class LocationService {
    
    static var shared = LocationService()
    
    var longitude: Double!
    var latitude: Double!
}
