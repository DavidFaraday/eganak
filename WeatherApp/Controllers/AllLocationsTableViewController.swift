//
//  AllLocationsTableViewController.swift
//  WeatherApp
//
//  Created by David Kababyan on 16/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import UIKit


protocol AllLocationsTableViewControllerDelegate {
    func didChooseLoacation(atIndex: Int, shouldRefresh: Bool)
}

class AllLocationsTableViewController: UITableViewController {

    //MARK: IBOutlets
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var tempSegmentOutlet: UISegmentedControl!
    
    //MARK: Vars
    var weatherData: [CityTempData]?
    var savedLocations: [WeatherLocation]?

    var delegate: AllLocationsTableViewControllerDelegate?
    var shouldRefresh = false
    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView
        
        loadTempFormatFromUserDefaults()
        loadLocationsFromUserDefaults()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return weatherData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainWeatherTableViewCell
        
    
        if weatherData != nil  {
            cell.generateCell(weatherData: weatherData![indexPath.row])
            
        }
        
        return cell
    }
    
    //MARK: TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didChooseLoacation(atIndex: indexPath.row, shouldRefresh: shouldRefresh)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        //so that we dont delete current location
        return indexPath.row != 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let locationToDelete = weatherData?[indexPath.row]
            weatherData?.remove(at: indexPath.row)

            removeLocationFromSavedLocations(location: locationToDelete!.city)
            tableView.reloadData()
        }
    }
    
    private func removeLocationFromSavedLocations(location: String) {

        if savedLocations != nil {
            for i in 0..<savedLocations!.count {

                let tempLocation = savedLocations![i]
                
                if tempLocation.city == location {
                    savedLocations?.remove(at: i)
                    saveNewLocationsToUserDefaults()
                    return
                }
            }
            
        }
    }
    
    private func saveNewLocationsToUserDefaults() {
        
        shouldRefresh = true
        
        userDefaults.set(try? PropertyListEncoder().encode(savedLocations!), forKey:"Locations")
        userDefaults.synchronize()
    }


    //MARK: IBActions    
    @IBAction func tempSegmentValueChanged(_ sender: UISegmentedControl) {
        updateTempFormatInUserDefaults(newValue: sender.selectedSegmentIndex)
    }
    
    
    //MARK: UserDefaults
    private func updateTempFormatInUserDefaults(newValue: Int) {
        //so that when we dismiss, it refreshes and sets the new temp format
        shouldRefresh = true
        userDefaults.set(newValue, forKey: "TempFormat")
        userDefaults.synchronize()
    }
    
    private func loadTempFormatFromUserDefaults() {
        
        if let index = userDefaults.value(forKey: "TempFormat") {
            tempSegmentOutlet.selectedSegmentIndex = index as! Int
        } else {
            tempSegmentOutlet.selectedSegmentIndex = 0
        }
    }
    
    private func loadLocationsFromUserDefaults() {
        
        if let data = userDefaults.value(forKey:"Locations") as? Data {
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            
        }
    }


    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseLocationSeg" {
            let vc = segue.destination as! ChooseCityViewController
            vc.delegate = self
        }
    }

}

extension AllLocationsTableViewController: ChooseCityTableViewControllerDelegate {
    func didAdd(newLoaction: WeatherLocation) {
        
        weatherData?.append(CityTempData(city: newLoaction.city, temp: 0.0))
        shouldRefresh = true
        tableView.reloadData()
    }
}
