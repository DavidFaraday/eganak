//
//  ChooseCityTableViewController.swift
//  WeatherApp
//
//  Created by David Kababyan on 15/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ChooseCityTableViewControllerDelegate {
    func didAdd(newLoaction: WeatherLocation)
}

class ChooseCityViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Vars
    var allLocations:[WeatherLocation] = []
    var filteredLocations:[WeatherLocation] = []
    let searchController = UISearchController(searchResultsController: nil)
    let userDefaults = UserDefaults.standard
    var savedLocations: [WeatherLocation]?
    var delegate: ChooseCityTableViewControllerDelegate?
    
    //MARK: ViewLifeCycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadFromUserDefaults()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        setupSearchController()
        
        self.tableView.tableHeaderView = searchController.searchBar
        
        setupTapGesture()
        loadLocationsFromCSV()
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "City or Country"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundImage = UIImage()
//        searchController.searchBar.tintColor = .white

    }
    
    @objc func tableTapped() {
        if searchController.isActive {
            searchController.dismiss(animated: true, completion: {
                self.dismiss(animated: true)
            })
        } else {
            dismiss(animated: true)
        }
    }
    
    
    
    
    //MARK: Get locations
    private func loadLocationsFromCSV() {
        
        if let path = Bundle.main.path(forResource: "location", ofType: "csv") {
//            var csvText = "city,country,countryCode\n"
            parseCVSAt(url: URL(fileURLWithPath: path))
        }
    }
    
    private func parseCVSAt(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if  let dataArr = dataEncoded?.components(separatedBy: "\n").map({ $0.components(separatedBy: ",") }) {
                
                var i = 0
                
                for line in dataArr {
                    
                    if line.count > 2 && i != 0 {
                        createLocation(line: line)
//                        let newLine = "\(line[1]),\(line[6]),\(line[5])\n"
//                        csvText.append(newLine)
                    }
                    
                    i += 1
                }
                
//                writeDataToFile(newLine: csvText)
                
                tableView.reloadData()
            }
        } catch  {
            print("\n Error read from CSV file: \n ", error.localizedDescription)
        }
    }
    
    private func createLocation(line: [String]) {
        allLocations.append(WeatherLocation(city: line.first!, country: line[1], countryCode: line.last!, isCurrentLocation: false))
    }
    
    

    
    //MARK: IBActions
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        if searchController.isActive {
            searchController.dismiss(animated: true, completion: {
                self.dismiss(animated: true)
            })
        } else {
            dismiss(animated: true)
        }
    }
    
    
    //MARK: UserDefaults
    
    private func saveToUserDefaults(location: WeatherLocation) {
        
        if savedLocations != nil {
            
            if !savedLocations!.contains(location) {
                savedLocations?.append(location)
            }
            
        } else {
            savedLocations = [location]
        }
        
        userDefaults.set(try? PropertyListEncoder().encode(savedLocations!), forKey:"Locations")
        userDefaults.synchronize()

    }
    
    private func loadFromUserDefaults() {
        
        if let data = userDefaults.value(forKey:"Locations") as? Data {
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)

        }
    }
    
}

extension ChooseCityViewController: UISearchResultsUpdating {
    
    //MARK: Search controler functions
    
    func filteredContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredLocations = allLocations.filter({ (location) -> Bool in
            
            return location.city.lowercased().contains(searchText.lowercased()) || location.country.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }

}








//not needed
func writeDataToFile(newLine: String) {
    
    let fileManager = FileManager.default
    do {
        let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
        let fileURL = path.appendingPathComponent("location.csv")
        try newLine.write(to: fileURL, atomically: true, encoding: .utf8)
    } catch {
        print("error creating file", error.localizedDescription)
    }
    
}


extension ChooseCityViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let location = filteredLocations[indexPath.row]
        cell.textLabel?.text = location.city
        cell.detailTextLabel?.text = location.country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveToUserDefaults(location: filteredLocations[indexPath.row])
        delegate?.didAdd(newLoaction: filteredLocations[indexPath.row])
        
        if searchController.isActive {
            searchController.dismiss(animated: true, completion: {
                self.dismiss(animated: true)
            })
        } else {
            dismiss(animated: true)
        }
        
    }
}
