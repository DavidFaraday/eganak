//
//  GlobalHelpers.swift
//  WeatherApp
//
//  Created by David Kababyan on 08/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import Foundation
import UIKit


func getWeatherIconFor(_ type: String) -> UIImage? {
    return UIImage(named: type)
}


func formatStringDecimalSize(_ stringToFormat: String) -> NSAttributedString {
    
    let mainNumberSize: CGFloat = 90
    let decimalNumberSize: CGFloat = 70
    
    let number = stringToFormat.split(separator: ".").first!
    let decimalPoint = stringToFormat.split(separator: ".").last!
    
    let numberString = NSAttributedString(string: String(number), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: mainNumberSize)])
    let decimalString = NSAttributedString(string: String(decimalPoint), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: decimalNumberSize)])
    let dotString = NSAttributedString(string: ".")
    let tempTypeSign = NSAttributedString(string: "C", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: mainNumberSize)])
    
    let finalText = NSMutableAttributedString()
    finalText.append(numberString)
    
    if decimalPoint != "0" {
        finalText.append(dotString)
        finalText.append(decimalString)
    }
    finalText.append(tempTypeSign)
    
    return finalText
}


func celsiusFromKelvin(kelvin: Double) -> Double {
    let kelvinTemp = 273.15
    
    return kelvin - kelvinTemp
}

func fahrenheitFrom(celsius: Double) -> Double {

    return (celsius * 9/5) + 32
}

func getTempBasedOnSettings(celsius: Double) -> Double {
    
    let format = returnTempFormatFromUserDefaults()
    if format == TempFormat.celsius {
        return celsius
    } else {
        return fahrenheitFrom(celsius: celsius)
    }
}

func returnTempFormatFromUserDefaults() -> String {
    
    if let temp = userDefaults.value(forKey: "TempFormat") {
        
        if temp as! Int == 0 {
            return TempFormat.celsius
        } else {
            return TempFormat.fahrenheit
        }
    } else {
        return TempFormat.celsius
    }
}

func currentDateFromUnix(unixDate: Double?) -> Date? {
    if unixDate != nil {
        return Date(timeIntervalSince1970: unixDate!)
    } else {
        return Date()
    }
}

