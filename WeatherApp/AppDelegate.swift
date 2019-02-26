//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by David Kababyan on 04/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    var locationManager: CLLocationManager?
    var coordinates: CLLocationCoordinate2D?

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        locationManagerStart()

        return true
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
//        locationMangerStop()
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
//        locationManagerStart()
    }


//    //MARK: Location Manager
//    func locationManagerStart() {
//        if locationManager == nil {
//            locationManager = CLLocationManager()
//            locationManager!.delegate = self
//            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager!.requestWhenInUseAuthorization()
//        }
//
//        locationManager!.startMonitoringSignificantLocationChanges()
//        print("starting")
//
//    }
    
//    func locationMangerStop() {
//        if locationManager != nil {
//            locationManager!.stopMonitoringSignificantLocationChanges()
//        }
//    }
//
//    //MARK: Location ManagerDelegate
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("failed to get location")
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//
//        switch status {
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization()
//            break
//        case .authorizedWhenInUse:
//            manager.startUpdatingLocation()
//            break
//        case .authorizedAlways:
//            manager.startUpdatingLocation()
//            break
//        case .restricted:
//            // restricted by e.g. parental controls. User can't enable Location Services
//            break
//        case .denied:
//            locationManager = nil
//            print("denied location")
//            // user denied your app access to Location Services, but can grant access from Settings.app
//            break
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("local")
//        coordinates = locations.last!.coordinate
//
//        if coordinates != nil {
//            print("did set")
//            LocationService.shared.latitude = coordinates!.latitude
//            LocationService.shared.longitude = coordinates!.longitude
//        }
//    }
    


}

