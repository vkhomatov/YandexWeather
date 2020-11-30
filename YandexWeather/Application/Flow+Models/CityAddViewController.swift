//
//  CityAddViewController.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 02.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit
import MapKit


class CityAddViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    private var searchBar = UISearchBar()
    private var searchResultsTable = UITableView()
    private var searchCompleter = MKLocalSearchCompleter()
    private var locationManager = LocationManager()

    
    private var searchResults = [MKLocalSearchCompletion](){
        didSet {
            DispatchQueue.main.async {
                    self.searchResultsTable.reloadData()
            }
        }
    }
    
    
    var addNewUserPlace: (() -> Void)?
    
    var place = UserPlace()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        createTable()
        createSearchBar()
        dismissKey()        
    }
    
    
    private func createSearchBar() {
        
        searchBar.delegate = self
        self.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchBar.placeholder = " Введите название объекта ..."
        self.searchBar.sizeToFit()
        self.searchBar.isTranslucent = false
        self.searchBar.delegate = self
        self.searchBar.barTintColor = .systemYellow
        view.addSubview(searchBar)
        
    }
    
    private func createTable() {
        self.searchResultsTable = UITableView(frame: view.bounds, style: .plain)
        self.searchResultsTable.delegate = self
        self.searchResultsTable.dataSource = self
        self.searchResultsTable.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.searchResultsTable.separatorStyle = .none
        view.addSubview(searchResultsTable)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        if searchText == "" {
            self.searchResults.removeAll()
        }
    }
    
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {        
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("completer: \(error)")
    }
    
}

extension CityAddViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
        
    }
    
//    func localTime(in timeZone: String) -> String {
//        
//        let f = ISO8601DateFormatter()
//        f.formatOptions = [.withInternetDateTime]
//        f.timeZone = TimeZone(identifier: timeZone)
//        return f.string(from: Date())
//        
//    }
}

extension CityAddViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let cell = tableView.cellForRow(at: indexPath)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            
            guard let name = response?.mapItems[0].name,
                let title = response?.mapItems[0].placemark.title,
                let coordinate = response?.mapItems[0].placemark.coordinate//,
              //  let placemark = response?.mapItems[0].placemark
                else { return }
            
            self.place = UserPlace(name: name, title: title, latitude: coordinate.latitude, longitude: coordinate.longitude)
//            self.place.coordinates = coordinate
//            self.place.name = name
//            self.place.title = title
    
//            print("placemark = \(placemark)")
//            
//            locationManager.getPlace(for: placemark.coordinate) { placeMark in
//            if let placeMark = placeMark  {
//                    if let time = placeMark.timeZone?.description {
//                                   print("Time = \(time)")
//                                  // self.place.time = self.localTime(in: time)
//                               }
//                }
//            }
//            
//            
//            if let time = placemark.coordinate timeZone?.description {
//                print("Time = \(time)")
//               // self.place.time = self.localTime(in: time)
//            }
//            
//            print("Локальное время = \(self.place.time)")
            
            
            
            
            //            if !self.places.contains(self.place) {
            //                self.places.append(self.place)
            //                print("userPlaces.append: объект \(String(describing: self.place.name)) был УСПЕШНО добавлен")
            //            } else {
            //                print("userPlaces.append: объект \(String(describing: self.place.name)) был добавлен ранее")
            //            }
            
            if let callback = self.addNewUserPlace {
                callback()
            }
            
            cell?.accessoryType = .checkmark

        }
    }
}


extension CityAddViewController {
    
    func dismissKey()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(CityAddViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
