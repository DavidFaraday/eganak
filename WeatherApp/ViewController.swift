//
//  ViewController.swift
//  WeatherApp
//
//  Created by David Kababyan on 04/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var pressureLable: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var uvLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var visibilityView: UIView!
    @IBOutlet weak var windView: UIView!
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var pressureView: UIView!
    @IBOutlet weak var sunsetView: UIView!
    @IBOutlet weak var sunriseView: UIView!

    @IBOutlet weak var uvIndexView: UIView!
    @IBOutlet weak var feelsLikeView: UIView!
    
    
    @IBOutlet weak var currentWeatherIconImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var location: WeatherLocation?
    
    //MARK: Vars
    var currentWeather: CurrentWeather!

    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!

    var weeklyWeatherForecastData: [WeeklyWeatherForecast] = []
    var dailyWeatherForecastData: [HourlyForecast] = []

    
    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerStart()
        horizontalScrollView.contentSize.height = 700
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did app")
        currentWeather = CurrentWeather()
        
        if location != nil {
            getWeeklyWeatherForecast(location: location!)
            getCurrentWeather(location: location!)
            getDailyWeatherForecast(location: location!)
        } else {
            locationAuthCheck()
        }
        
        roundEdges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationMangerStop()
    }
    
    
    //MARK: Download Wheather
    
    private func getCurrentWeather(location: WeatherLocation?) {
//        currentWeather.getCurrentWeather(location: location) {
//            self.updateUI()
//        }
    }

    
    private func getWeeklyWeatherForecast(location: WeatherLocation?) {
//        WeatherForecast.downloadWeeklyForecastWeather(location: location) { (weatherForecasts) in
//
//            self.weeklyWeatherForecastData = weatherForecasts
//            self.tableView.reloadData()
//        }
    }
    
    private func getDailyWeatherForecast(location: WeatherLocation?) {
//        DailyForecast.downloadDailyForecastWeather(location: location) { (weatherForecasts) in
//            
//            self.dailyWeatherForecastData = weatherForecasts
//            self.collectionView.reloadData()
//        }
    }

    //MARK: UpdateUI
    private func updateUI() {
        cityLabel.text = currentWeather.city
        dateLabel.text = "Today, " + "\(currentWeather.date.shortDate())"
        
        currentWeatherIconImageView.image = getWeatherIconFor(currentWeather.weatherIcon)
        currentTempLabel.attributedText = formatStringDecimalSize(String(format: "%.1f", currentWeather.currentTemp))
        pressureLable.text = String(format: "%.0f mb", currentWeather.pressure)
        humidityLabel.text = String(format: "%.0f ", currentWeather.humidity) + "%"
        windSpeedLabel.text = String(format: "%.1f m/sec", currentWeather.windSpeed)
        visibilityLabel.text = String(format: "%.0f km", currentWeather.visibility)
        feelsLikeLabel.text = String(format: "%.1f", currentWeather.feelsLike)
        uvLabel.text = String(format: "%.1f", currentWeather.uv)
        sunriseLabel.text = currentWeather.sunrise
        sunsetLabel.text = currentWeather.sunset
        
        weatherTypeLabel.text = currentWeather.weatherType
    }
    
    private func roundEdges() {
        visibilityView.layer.cornerRadius = 8.0
        windView.layer.cornerRadius = 8.0
        humidityView.layer.cornerRadius = 8.0
        pressureView.layer.cornerRadius = 8.0
        sunsetView.layer.cornerRadius = 8.0
        sunriseView.layer.cornerRadius = 8.0
        uvIndexView.layer.cornerRadius = 8.0
        feelsLikeView.layer.cornerRadius = 8.0
    }
    
    
    //MARK: Location Manager
    func locationManagerStart() {
        
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
        }
        locationManager!.startMonitoringSignificantLocationChanges()
    }
    
    func locationMangerStop() {
        if locationManager != nil {
            locationManager!.stopMonitoringSignificantLocationChanges()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed to get location")
    }
    
    func locationAuthCheck() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {

            currentLocation = locationManager!.location?.coordinate

            if currentLocation != nil {
                LocationService.shared.latitude = currentLocation.latitude
                LocationService.shared.longitude = currentLocation.longitude
                
                getWeeklyWeatherForecast(location: nil)
                getDailyWeatherForecast(location: nil)
                getCurrentWeather(location: nil)
            }
        } else {
            locationManager?.requestWhenInUseAuthorization()
            locationAuthCheck()
        }
    }
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weatherToAllList" {
            let vc = segue.destination as! AllLocationsTableViewController
//            vc.delegate = self
            
        }
    }
    


}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weeklyWeatherForecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return dailyWeatherForecastData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath)

        
        return cell
    }
    
}

//extension ViewController: AllLocationsTableViewControllerDelegate {
//
//    func didChooseLoacation(location: Location) {
//
//        self.location = location
//
//    }
//
//}

