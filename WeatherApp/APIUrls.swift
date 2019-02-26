//
//  Extras.swift
//  WeatherApp
//
//  Created by David Kababyan on 04/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import Foundation
import UIKit

let CURRENTLOCATIONAPI_URL = "https://api.weatherbit.io/v2.0/current?&lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&key=2b72f0ece8d1479590ba1e68df57071f"

let CURRENTLOCATIONWEEKFORECASTAPI_URL = "https://api.weatherbit.io/v2.0/forecast/daily?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&days=7&key=2b72f0ece8d1479590ba1e68df57071f"

let CURRENTLOCATIONDAILYFORECASTAPI_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&hours=24&key=2b72f0ece8d1479590ba1e68df57071f"



let userDefaults = UserDefaults.standard

//typealias DownloadCompleted = () -> ()




