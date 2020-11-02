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
    

    private var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self

        createTable()
        createSearchBar()
        
    }
    
    
    private func createSearchBar() {
        
        searchBar.delegate = self
        
        self.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
       // self.searchBar.obscuresBackgroundDuringPresentation = false
        
        self.searchBar.placeholder = " Введите название объекта ..."
        self.searchBar.sizeToFit()
        self.searchBar.isTranslucent = false
        self.searchBar.delegate = self
        view.addSubview(searchBar)

        
    }
    
    private func createTable() {
        self.searchResultsTable = UITableView(frame: view.bounds, style: .plain)
        self.searchResultsTable.delegate = self
        self.searchResultsTable.dataSource = self
        
        self.searchResultsTable.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(searchResultsTable)
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        searchResults = completer.results
        
        searchResultsTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
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
        
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension CityAddViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }
            
            print(name)
            
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            
            print(lat)
            print(lon)
            
        }
    }
}



