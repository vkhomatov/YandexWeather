//
//  CityAddViewController.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 02.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit
import MapKit
import PinLayout



class CityAddViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    private var searchBar = UISearchBar()
    private var searchResultsTable = UITableView()
    
    private var searchCompleter = MKLocalSearchCompleter()
    
//    let VC = MainViewController()
    

    private var searchResults = [MKLocalSearchCompletion]()
 //   private var filtrSearchResults = [MKLocalSearchCompletion]()
    
    var addNewUserPlace: (() -> Void)?

    //var userPlaces = [String : CLLocationCoordinate2D]()
    var places = [userPlace]() //{
//        didSet {
//            searchResultsTable.reloadData()
//        }
//    }
    
    
    var place = userPlace()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchCompleter.delegate = self

        createTable()
        createSearchBar()
        
    }
    
    deinit {
        print("Я ушел")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
      //  print("Я спрятался")
        
        if let callback = self.addNewUserPlace {
            callback()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
         //  print("Я появился")
           
        self.places.removeAll()

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
        self.searchBar.barTintColor = .systemYellow
        view.addSubview(searchBar)

        
    }
    
    private func createTable() {
        self.searchResultsTable = UITableView(frame: view.bounds, style: .plain)
        self.searchResultsTable.delegate = self
        self.searchResultsTable.dataSource = self
      //  self.searchResultsTable.sizeToFit()

       self.searchResultsTable.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.searchResultsTable.separatorStyle = .none

        view.addSubview(searchResultsTable)
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        if searchText == "" {
            self.searchResults.removeAll()
            self.searchResultsTable.reloadData()
        }
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
        
//        self.filtrSearchResults = self.searchResults.filter({ (search1, search2) -> Bool in
//
//        })
        
//        for search in searchResults {
//            if search.title ==  {
//                filtrSearchResults.append(search)
//
//            }
//        }
            
        let searchResult = searchResults[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.selectionStyle = .none
        
        
//        let plus = UILabel(frame: .zero)
//        plus.text = "+"
//        plus.font = .systemFont(ofSize: 20.0, weight: .medium)
//        plus.textColor = .systemYellow
//        plus.pin.after(of: cell, aligned: .center)
//            .vCenter()
//            .right(10)
//            .marginRight(3.5)
//        cell.backgroundView?.addSubview(plus)
//        cell.backgroundView?.layoutSubviews()

        
        
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
            
            guard let placemark = response?.mapItems[0].placemark else {
                return
            }
//
            guard let title = response?.mapItems[0].placemark.title else {
                return
            }
            
//            guard let adress = response?.mapItems[0].placemark.subtitle else {
//                return
//            }
            
            print("title = \(title)")
            print("name = \(name)")
            print("placemark = \(placemark)")
            print("coordinate = \(coordinate)")
           
            self.place.coordinates = coordinate
            self.place.name = name
            self.place.title = title

            
            //self.places.append(self.place)
            
           // self.userPlaces.updateValue(coordinate, forKey: title)
            
                
          //  if let VC = self.parent as? MainViewController {
                
            if !self.places.contains(self.place) {
                self.places.append(self.place)
                print("userPlaces.append: объект \(String(describing: self.place.name)) был УСПЕШНО добавлен")
                } else {
                    print("userPlaces.append: объект \(String(describing: self.place.name)) был добавлен ранее")
                }
          //  }
       //     self.userPlace = placemark as CLPlacemark
//            if let callback = self.addNewUserPlace {
//                callback()
//            }

            
//            
//            let lat = coordinate.latitude
//            let lon = coordinate.longitude
//            
//            print(lat)
//            print(lon)
            
        }
    }
}



