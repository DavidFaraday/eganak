//
//  WeatherForecast.swift
//  WeatherApp
//
//  Created by David Kababyan on 05/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeeklyWeatherForecast {
    
    private var _date: Date!
    private var _temp: Double!
    private var _feelsLike: Double!
    private var _wheatherType: String!
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
    
    var feelsLike: Double {
        if _feelsLike == nil {
            _feelsLike = 0.0
        }
        return _feelsLike
    }
    
    var wheatherType: String {
        if _wheatherType == nil {
            _wheatherType = ""
        }
        return _wheatherType
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

        self._temp = getTempBasedOnSettings(celsius:json["temp"].double ?? 0.0)
        self._feelsLike = json["app_max_temp"].double
        self._date = currentDateFromUnix(unixDate: json["ts"].double!)
        self._wheatherType = json["weather"]["description"].stringValue
        self._weatherIcon = json["weather"]["icon"].stringValue
    }

    
    class func downloadWeeklyForecastWeather(location: WeatherLocation, completed: @escaping(_ weatherForecast : [WeeklyWeatherForecast])->Void) {

        var WEEKFORECASTAPI_URL:String!
        
        if !location.isCurrentLocation {
            WEEKFORECASTAPI_URL = String(format: "https://api.weatherbit.io/v2.0/forecast/daily?city=%@,%@&days=7&key=2b72f0ece8d1479590ba1e68df57071f", location.city, location.countryCode)
        } else {
            WEEKFORECASTAPI_URL = CURRENTLOCATIONWEEKFORECASTAPI_URL
        }

        Alamofire.request(WEEKFORECASTAPI_URL).responseJSON { (response) in
            let result = response.result
            
            var forecastArray: [WeeklyWeatherForecast] = []

            if result.isSuccess {
                
                if let dictionary = result.value as? Dictionary<String, AnyObject> {
                    if var list = dictionary["data"] as? [Dictionary<String, AnyObject>] {
                        
                        list.remove(at: 0) //remove current day
                        for item in list {
                            let forecast = WeeklyWeatherForecast(weatherDictionary: item)
                            forecastArray.append(forecast)
                        }
                    }
                }

                completed(forecastArray)
            } else {
                print("no forecast data")
                completed(forecastArray)
            }
        }
    }
}

