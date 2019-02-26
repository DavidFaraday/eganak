//
//  DailyForecast.swift
//  WeatherApp
//
//  Created by David Kababyan on 13/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HourlyForecast {
    
    private var _date: Date!
    private var _temp: Double!
    private var _weatherIcon: String!
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var temp: Double {
        if _temp == nil {
            _temp = 0.0
        }
        return _temp
    }

    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    
    init(weatherDictionary: Dictionary<String,AnyObject>) {
        
        let json = JSON(weatherDictionary)

        //TO DO: set temp type based on settings
        
        self._temp = getTempBasedOnSettings(celsius: json["temp"].double ?? 0.0)
        self._date = currentDateFromUnix(unixDate: json["ts"].double!)
        self._weatherIcon = json["weather"]["icon"].stringValue
    }
    
        
    class func downloadDailyForecastWeather(location: WeatherLocation, completed: @escaping(_ weatherForecast : [HourlyForecast])->Void) {
        
        var DAILYFORECASTAPI_URL:String!

        if !location.isCurrentLocation {
            DAILYFORECASTAPI_URL = String(format: "https://api.weatherbit.io/v2.0/forecast/hourly?city=%@,%@&hours=24&key=2b72f0ece8d1479590ba1e68df57071f", location.city, location.countryCode)
        } else {
            DAILYFORECASTAPI_URL = CURRENTLOCATIONDAILYFORECASTAPI_URL
        }


        Alamofire.request(DAILYFORECASTAPI_URL).responseJSON { (response) in
            let result = response.result
            
            var forecastArray: [HourlyForecast] = []

            if result.isSuccess {
                
                if let dictionary = result.value as? Dictionary<String, AnyObject> {
                    if let list = dictionary["data"] as? [Dictionary<String, AnyObject>] {

                        for item in list {
                            let forecast = HourlyForecast(weatherDictionary: item)
                            forecastArray.append(forecast)
                        }
                    }
                }
                
                completed(forecastArray)
            } else {
                completed(forecastArray)
                print("no forecast data")
            }
        }
    }
    
    
    
}
