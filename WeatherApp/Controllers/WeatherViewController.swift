//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by David Kababyan on 23/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController, CLLocationManagerDelegate {


    //MARK: IBOutlets
    @IBOutlet weak var weatherScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    //MARK: Vars
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var allWeatherViews: [WeatherView] = []
    var allLocations:[WeatherLocation] = []
    var allWeatherData: [CityTempData] = [] // for allLocationsVC

    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
    
    var shouldRefresh = true
    
    //MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManagerStart()
        weatherScrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if shouldRefresh {
            allLocations = []
            allWeatherViews = []
            removeViewsFromScrollView()
            //TODO
            locationAuthCheck()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationMangerStop()
    }
    
    
    private func getWeather() {
        loadLocationsFromUserDefaults()
        createWeatherViews()
        addWeatherToScrollView()
        setPageControllPageNumber()
    }
    
    private func createWeatherViews() {
        
        for _ in allLocations {
            //add weatherView for each loaction to array
            allWeatherViews.append(WeatherView())
        }
    }
    

    
    private func addWeatherToScrollView() {

        for i in 0..<allWeatherViews.count {

            let weatherView = allWeatherViews[i]
            let location = allLocations[i]

            //get weather info and add to weather
            getCurrentWeather(weatherView: weatherView, location: location)
            getWeeklyWeatherForecast(weatherView: weatherView, location: location)
            getHourlyWeatherForecast(weatherView: weatherView, location: location)
            
            let xPos = self.view.frame.width * CGFloat(i)
            weatherView.frame = CGRect(x: xPos, y: 0, width: weatherScrollView.bounds.width, height: weatherScrollView.bounds.height)
            
            weatherScrollView.addSubview(weatherView)
            weatherScrollView.contentSize.width = weatherView.frame.width * CGFloat(i + 1)
            
        }
    }
    
    private func removeViewsFromScrollView() {
        for view in weatherScrollView.subviews {
            view.removeFromSuperview()
        }
    }

    //MARK: Download Wheather
    
    private func getCurrentWeather(weatherView: WeatherView, location: WeatherLocation) {
        
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather(location: location) { (success) in

            if location.isCurrentLocation {
                self.updateCurrentLocationInArray(newName: weatherView.currentWeather.city)
            }
            
            weatherView.refreshData(successful: success)
            self.generateWeatherList()
        }
        
    }
    
    
    private func getWeeklyWeatherForecast(weatherView: WeatherView, location: WeatherLocation) {
        WeeklyWeatherForecast.downloadWeeklyForecastWeather(location: location) { (weatherForecasts) in
            
            weatherView.weeklyWeatherForecastData = weatherForecasts
            weatherView.tableView.reloadData()
        }
    }
    
    private func getHourlyWeatherForecast(weatherView: WeatherView, location: WeatherLocation) {
        HourlyForecast.downloadDailyForecastWeather(location: location) { (weatherForecasts) in
            
            weatherView.dailyWeatherForecastData = weatherForecasts
            weatherView.hourlyCollectionView.reloadData()
        }
    }

    
    //MARK: PageControll

    private func setPageControllPageNumber() {
        pageControl.numberOfPages = allWeatherViews.count
    }

    private func updatePageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }

    
    private func updateCurrentLocationInArray(newName: String) {
        
        for i in 0..<allWeatherData.count {
            var tempData = allWeatherData[i]

            if tempData.city == "" {
                allWeatherData.remove(at: i)
                
                tempData.city = newName
                allWeatherData.insert(tempData, at: i)
            }
        }
    }
    
    
    //MARK: LoadUserDefaults
    
    private func loadLocationsFromUserDefaults() {
        
        let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)

        if let data = userDefaults.value(forKey:"Locations") as? Data {
            allLocations = try! PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            
            if allLocations.count > 0 {
                //+ add current location to the beginning of array
                allLocations.insert(currentLocation, at: 0)
            } else {
                allLocations.insert(currentLocation, at: 0)
            }
            
        } else {
            print("no user data")
            allLocations.append(currentLocation)
        }
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
                
                getWeather()
                
            }
        } else {
            locationManager?.requestWhenInUseAuthorization()
            locationAuthCheck()
        }
    }
    
    func generateWeatherList() {

        allWeatherData = []
        
        for weatherView in allWeatherViews {
            allWeatherData.append(CityTempData(city: weatherView.currentWeather.city, temp: weatherView.currentWeather.currentTemp))
        }

    }

    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allLocationsSeg" {
            let vc = segue.destination as! AllLocationsTableViewController

            vc.weatherData = allWeatherData
            vc.delegate = self
        }
    }
    

}

extension WeatherViewController: AllLocationsTableViewControllerDelegate {
    
    func didChooseLoacation(atIndex: Int, shouldRefresh: Bool) {
        
        self.shouldRefresh = shouldRefresh
        
        let viewNumber = CGFloat(integerLiteral: atIndex)
        let newOffset = CGPoint(x: (weatherScrollView.frame.width + 1.0) * viewNumber, y: 0)
        weatherScrollView.setContentOffset(newOffset, animated: true)
        updatePageControlSelectedPage(currentPage: atIndex)
    }
}


extension WeatherViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        updatePageControlSelectedPage(currentPage: Int(round(value)))
    }
}
