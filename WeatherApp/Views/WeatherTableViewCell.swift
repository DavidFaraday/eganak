//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by David Kababyan on 22/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateCell(forecast: WeeklyWeatherForecast) {
        dayOfTheWeekLabel.text = forecast.date.dayOfTheWeek()
        weatherIconImageView.image = getWeatherIconFor(forecast.weatherIcon)
        tempLabel.text = String(format: "%.0f%@", forecast.temp, returnTempFormatFromUserDefaults())
    }
    
}
