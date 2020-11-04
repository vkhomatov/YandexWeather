//
//  ViewController.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 01.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts


struct userPlace: Equatable {
    
    static func == (lhs: userPlace, rhs: userPlace) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name  = String()
    var title = String()
    var coordinates = CLLocationCoordinate2D()
    
}

class MainViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    private var locationManager = LocationManager()
    
    private let cityVC = CityAddViewController()
    
    private var tableView = UITableView()
    
    private let weather = WeatherService()
    
    private let identifire = "cityCell"
    
    private var currentLocation = CLLocation()
    
    var places = [userPlace]()  {
        didSet {
            tableView.reloadData()
        }
    }
    
    var place = userPlace()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTable()
        self.title = "Мои города"
        setupNavbar()
        
    }
    
    func CityWeatherLoad(city: userPlace, days: String) {
        
        self.weather.loadWeatherData(coordinate: city.coordinates, days: days) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
                
            case let .success(weather):
                
           //     guard !weather.isEmpty else { return }
                print("\nПрогноз погоды для города \(city.name) на данный момент\n")
                
                print("latitude = \(city.coordinates.latitude)")
                print("longitude = \(city.coordinates.longitude)")

                print("temp = \(weather.temp)")
                print("humidity = \(weather.humidity)")
                print("feels_like = \(weather.feels_like)")
                print("condition = \(weather.condition)")
                print("icon = \(weather.icon)")
                print("season = \(weather.season)")
                print("url = \(weather.url)")

                

                print("\nПрогноз погоды по датам:\n")

                weather.forecasts.forEach { forecast in
                    print(forecast.date)
                    print("temp_max = \(forecast.temp_max)")
                    print("temp_min = \(forecast.temp_min)")
                    print("feels_like = \(forecast.feels_like)")
                    print("humidity = \(forecast.humidity)")
                    print("sunrise = \(forecast.sunrise)")
                    print("sunset = \(forecast.sunset)")
                    print("condition = \(forecast.condition)")
                    print("icon = \(forecast.icon)")
                    print("wind_speed = \(forecast.wind_speed)\n")
                
                }
                
            case .failure(_):
                print("не удалось загрузить погодные данные для объекта \(city)")
                
            }
        }
        
        //
        //                       DispatchQueue.main.async {
        //                           self.weather.loadWeatherData(city: "Москва", days: "2")
        //                       }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            
            self.locationManager.getNewLocation = { [weak self] in
                guard let self = self else { return }
                
                self.currentLocation = self.locationManager.userLocation
                
                self.locationManager.getPlace(for: self.currentLocation) { placeMark in
                    if let placeMark = placeMark  {
                        
                        print("placeMark.formattedAddress = \(String(describing: placeMark.formattedAddress))")
                        
                        let mkPlacemark = MKPlacemark(placemark: placeMark)
                        
                        guard let title = mkPlacemark.title else {
                            return
                        }
                        
                        guard let name = mkPlacemark.name else {
                            return
                        }
                        
                        self.place.coordinates = mkPlacemark.coordinate
                        self.place.name = name
                        self.place.title = title
                        
                        self.CityWeatherLoad(city: self.place, days: "2")

                        
                        if !self.places.contains(self.place) {
                            self.places.append(self.place)
                            print("userPlaces.append: объект \(String(describing: self.place.name)) был УСПЕШНО добавлен")
                        } else {
                            print("userPlaces.append: объект \(String(describing: self.place.name)) был добавлен ранее")
                        }
                      
                        print("\nlocality = \(String(describing: placeMark.locality))")
                        
                        print("\nadministrativeArea = \(String(describing: placeMark.administrativeArea))")
                        print("\ncountry = \(String(describing: placeMark.country))")
                    } else {
                        print("locationManager.getPlace: объект не найден")
                    }
                    
                    
                }
                                
                print("\nlocations 2 = \(String(describing: self.currentLocation.coordinate.latitude)) \(String(describing: self.currentLocation.coordinate.longitude))")
                self.locationManager.locationManager.stopUpdatingLocation()
                
                
            }

        }
        
        self.cityVC.addNewUserPlace = { [weak self] in
            guard let self = self else { return }
            
            if !self.cityVC.places.isEmpty {
                for place in self.cityVC.places {
                    if !self.places.contains(place) {
                        self.places.append(place)
                        self.CityWeatherLoad(city: place, days: "7")
                        print("userPlaces.append: объект \(String(describing: place.name) ) был успешно добавлен")
                    }
                }
            }
        }
        
    }
    
    
    
    private func setupNavbar() {
        
        let addCustomerButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                action: #selector(self.addNewCity))
        self.navigationItem.rightBarButtonItem = addCustomerButton
    }
    
    private func createTable() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifire)
        
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.separatorStyle = .none
        // self.tableView.sizeToFit()
        
        
        // let footerView = MainTableFooter(frame: .init(x: 100, y: 100, width: 400, height: 200))
        // tableView.tableFooterView = footerView
        // tableView.tableFooterView?.backgroundColor = .yellow
        
        view.addSubview(tableView)
        
        self.tableView.register(MainCityCell.self, forCellReuseIdentifier: identifire)
        
        
        
    }
    
    
    
    @objc private func addNewCity() {
        
        
        //        cityVC.modalPresentationStyle = UIModalPresentationStyle.custom
        //        cityVC.transitioningDelegate = self
        //
        
        //navigationController?.pushViewController(cityVC, animated: true)
        present(cityVC, animated: true, completion: nil)
        
    }
    
    
}


extension MainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("push \(indexPath.row)")
        
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //  self.tableView.reloadSections([indexPath.section], with: .automatic)
            self.places.remove(at: indexPath.section)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

extension MainViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath) as? MainCityCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        // cell.objectNameLabel.text =
        cell.objectNameLabel.text = self.places[indexPath.section].name
        cell.objectDescriptionLabel.text = self.places[indexPath.section].title
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.places.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    
}

extension MainViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        
        print("textSearched = \(textSearched)")
    }
}


extension CLPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else {
            return nil
        }
        let formatter = CNPostalAddressFormatter()
        print(
            postalAddress.city,
            postalAddress.country,
            postalAddress.subLocality,
            postalAddress.subAdministrativeArea,
            postalAddress.state)
        return formatter.string(from: postalAddress)
    }
}
