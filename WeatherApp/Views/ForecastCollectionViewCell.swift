//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by David Kababyan on 22/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func generateCell(weather: HourlyForecast) {
        
        timeLabel.text = weather.date.time()
        weatherIconImageView.image = getWeatherIconFor(weather.weatherIcon)
        tempLabel.text = String(format: "%.0f%@", weather.temp, returnTempFormatFromUserDefaults())
    }

}
