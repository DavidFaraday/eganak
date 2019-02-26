//
//  WeatherView.swift
//  WeatherApp
//
//  Created by David Kababyan on 21/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import UIKit

class WeatherView: UIView {

    //MARK: Outlets
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bottomContainer: UIView!
    
    @IBOutlet weak var weatherTypeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    
    //MARK: Vars
    var currentWeather: CurrentWeather!
    var weeklyWeatherForecastData: [WeeklyWeatherForecast] = []
    var dailyWeatherForecastData: [HourlyForecast] = []
    var weatherInfoData: [WeatherInfo] = []

    
    override init(frame: CGRect) {
        super .init(frame: frame)

        mainInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)

        mainInit()
    }
    
    private func mainInit() {
        
        Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setupTableView()
        setupHourlyCollectionView()
        setupInfoCollectionView()
    }
    
    func refreshData(successful: Bool) {
        if currentWeather != nil {
            setupCurrentWeatherInfo(success: successful)
            setupWeatherInfo()
            infoCollectionView.reloadData()
        }
    }
    
    private func setupTableView() {
        // For registering nib files
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func setupHourlyCollectionView() {
        hourlyCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        hourlyCollectionView.dataSource = self
    }
    
    private func setupInfoCollectionView() {
        infoCollectionView.register(UINib(nibName: "InfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        infoCollectionView.dataSource = self
    }


    private func setupCurrentWeatherInfo(success: Bool) {
        cityNameLabel.text = currentWeather.city
        dateLabel.text = "Today, " + "\(currentWeather.date.shortDate())"
        if success {
            tempLabel.text = String(format: "%.0f%@", currentWeather.currentTemp, returnTempFormatFromUserDefaults())
        } else {
            tempLabel.text = "No Data"
        }
        weatherTypeLabel.text = currentWeather.weatherType
    }
    


    private func setupWeatherInfo() {
        
        let windInfo = WeatherInfo(infoText: String(format: "%.1f m/sec", currentWeather.windSpeed), nameText: nil, image: getWeatherIconFor("wind"))
        let humidityInfo = WeatherInfo(infoText: String(format: "%.0f ", currentWeather.humidity) + "%", nameText: nil, image: getWeatherIconFor("humidity"))
        let pressureInfo = WeatherInfo(infoText: String(format: "%.0f mb", currentWeather.pressure), nameText: nil, image: getWeatherIconFor("pressure"))
        let visibilityInfo = WeatherInfo(infoText: String(format: "%.0f km", currentWeather.visibility), nameText: nil, image: getWeatherIconFor("visibility"))
        let feelsLikeInfo = WeatherInfo(infoText: String(format: "%.1f", currentWeather.feelsLike), nameText: nil, image: getWeatherIconFor("feelsLike"))
        let uvInfo = WeatherInfo(infoText: String(format: "%.1f", currentWeather.uv), nameText: "UV Index", image: nil)
        let sunriseInfo = WeatherInfo(infoText: currentWeather.sunrise, nameText: nil, image: getWeatherIconFor("sunrise"))
        let sunsetInfo = WeatherInfo(infoText: currentWeather.sunset, nameText: nil, image: getWeatherIconFor("sunset"))

        weatherInfoData = [windInfo, humidityInfo, pressureInfo, visibilityInfo, feelsLikeInfo, uvInfo, sunriseInfo, sunsetInfo]
//        pressureLable.text = String(format: "%.0f mb", currentWeather.pressure)
//        humidityLabel.text = String(format: "%.0f ", currentWeather.humidity) + "%"
//        windLabel.text = String(format: "%.1f m/sec", currentWeather.windSpeed)
//        visibilityLabel.text = String(format: "%.0f km", currentWeather.visibility)
//        feelsLikeLabel.text = String(format: "%.1f", currentWeather.feelsLike)
//        uvLabel.text = String(format: "%.1f", currentWeather.uv)
//        sunriseLabel.text = currentWeather.sunrise
//        sunsetLabel.text = currentWeather.sunset
    }
    

}

extension WeatherView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return weeklyWeatherForecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell

        cell.generateCell(forecast: weeklyWeatherForecastData[indexPath.row])
        return cell
    }
}


extension WeatherView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyCollectionView {
            return dailyWeatherForecastData.count
        } else {
            return weatherInfoData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == hourlyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ForecastCollectionViewCell
            
            cell.generateCell(weather: dailyWeatherForecastData[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! InfoCollectionViewCell
            
            cell.generateCell(weatherInfo: weatherInfoData[indexPath.row])
            return cell
        }
    }
}
