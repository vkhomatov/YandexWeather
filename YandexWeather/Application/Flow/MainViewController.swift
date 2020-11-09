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
import SVGKit

//import Contacts


struct UserPlace: Equatable {
    
    static func == (lhs: UserPlace, rhs: UserPlace) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name  = String()
    var title = String()
    var coordinates = CLLocationCoordinate2D()
    var time = String()
}

class MainViewController: UIViewController {
    
    private var locationManager = LocationManager()
    private let cityAddVC = CityAddViewController()
    private let cityWeatherVC = CityWeatherViewController()
    
    var sendDataTocityWeatherVC: (() -> Void)?
    
    private var tableView = UITableView()
    private let weather = WeatherService()
    private let identifire = "cityCell"
    private var currentLocation = CLLocation()
    private var refreshControl = UIRefreshControl()
    private var weatherImages = [String : UIImage?]()

    var places = [UserPlace]()  {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var weathers = [CityWeather]() {
        didSet {
            
            DispatchQueue.main.async {
                if !self.weathers.isEmpty {
                    self.tableView.reloadData()
                    self.title = "Моя погода"
                }
            }
        }
        
    }
    
   // var myWeather = [UserPlace : CityWeather]()
    
    
    fileprivate func getCurrentLocation() {
        self.locationManager.getNewLocation = { [weak self] in
            guard let self = self else { return }
            
            self.currentLocation = self.locationManager.userLocation
            
            self.locationManager.getPlace(for: self.currentLocation) { placeMark in
                if let placeMark = placeMark  {
                    
                    let mkPlacemark = MKPlacemark(placemark: placeMark)
                    
                    guard let name = mkPlacemark.name,
                          let title = mkPlacemark.title
                        else { return }
                    
                    var place = UserPlace()
                    
                    
                 //   print("mkPlacemark.timeZone?.secondsFromGMT() =\(placeMark.timeZone?.description)")
                    place.coordinates = mkPlacemark.coordinate
                    place.name = name
                    place.title = title
                    
                    if !self.places.contains(place) {
                        self.places.append(place)
                        
                        self.CityWeatherLoad(coordinates: place.coordinates, days: "7")
                        //self.tableView.reloadData()
                    }
                    
                } else {
                    print("locationManager.getPlace: объект не найден")
                }
            }
            self.locationManager.locationManager.stopUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Моя погода"
        createTable()
        setupNavbar()
        
        refreshControl.addTarget(self, action:  #selector(getNewWeather), for: .valueChanged)
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = .systemYellow
        
        getCurrentLocation()
        addWeather()

    }
    
    
    func addWeather() {
       // DispatchQueue.main.async {
            self.cityAddVC.addNewUserPlace = { [weak self] in
                guard let self = self else { return }
                let newPlace = self.cityAddVC.place
                if !self.places.contains(newPlace) {
                    self.places.append(newPlace)
                    self.CityWeatherLoad(coordinates: newPlace.coordinates, days: "7")
                    print("userPlaces.append: объект \(String(describing: newPlace.name) ) был УСПЕШНО добавлен")
                } else {
                    print("userPlaces.append: объект \(String(describing: newPlace.name) ) был добавлен ранее")
                }
            }
      //  }
        
        //        self.cityAddVC.addNewUserPlace = { [weak self] in
        //            guard let self = self else { return }
        //
        //            if !self.cityAddVC.places.isEmpty {
        //                for place in self.cityAddVC.places {
        //                    if !self.places.contains(place) {
        //                        self.places.append(place)
        //                      //  self.cityWeatherVC.places.append(place)
        //                        self.CityWeatherLoad(coordinates: place.coordinates, days: "7")
        //                       // print("userPlaces.append: объект \(String(describing: place.name) ) был успешно добавлен")
        //                    }
        //
        //                }
        //
        //            }
        //        }
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
    
    
    func CityWeatherLoad(coordinates: CLLocationCoordinate2D, days: String) {
        
        self.title = "Загрузка данных ..."
        
        self.weather.loadWeatherData(coordinate: coordinates, days: days) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(weather):
                
                
                // загрузка с сервера и кеширование картинок с погодой в словать
                
                if self.weatherImages[weather.icon] == nil {
                    // скачиваем картинку погоды
                    if let url = URL(string: weather.icon) {
                        let data = try? Data(contentsOf: url)
                        let anSVGImage: SVGKImage = SVGKImage(data: data)
                        weather.weatherImage = anSVGImage.uiImage
                        self.weatherImages.updateValue(weather.weatherImage, forKey: weather.icon)
                        //print("Wheather: картинка загружена из сети в словорь : \n\(weather.icon)")

                    }
                } else {
                    if let image = self.weatherImages[weather.icon] {
                        if let image = image {
                            weather.weatherImage = image
                        }
                        //print("Wheather: картинка загружена из словоря : \n\(weather.icon)")
                    }
                }
                
                for forecast in weather.forecasts {
                    if self.weatherImages[forecast.icon] == nil {
                        // скачиваем картинку погоды
                        if let url = URL(string: forecast.icon) {
                            let data = try? Data(contentsOf: url)
                            let anSVGImage: SVGKImage = SVGKImage(data: data)
                            forecast.weatherImage = anSVGImage.uiImage
                            self.weatherImages.updateValue(forecast.weatherImage, forKey: forecast.icon)
                          //  print("Forecast: картинка загружена из сети в словорь : \n\(weather.icon)")
                        }
                    } else {
                        if let image = self.weatherImages[forecast.icon] {
                            if let image = image {
                                forecast.weatherImage = image
                            }
                          //  print("Forecast: картинка загружена из словоря : \n\(forecast.icon)")
                        }
                    }
                }
            
                for place in self.places  {
                    if (place.coordinates.latitude == coordinates.latitude) && (place.coordinates.longitude == coordinates.longitude) {
                        if let num = self.places.firstIndex(of: place) {
                            if self.weathers.count-1 < num {
                                self.weathers.append(CityWeather())
                            }
                            if self.places.count-1 < num {
                                self.weathers.append(contentsOf: repeatElement(CityWeather(), count: num - self.weathers.count))
                            }
                            self.weathers[num] = weather
                        }
                    }
                }
    
            case .failure(_):
                print("не удалось загрузить погодные данные для объекта")
                self.title = "Моя погода [нет данных]"
            }
        }
    }
    
    
    private func setupNavbar() {
        
        let addCustomerButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNewCity))
        self.navigationItem.rightBarButtonItem = addCustomerButton
    }
    
    private func createTable() {
        
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifire)
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.separatorStyle = .none
        view.addSubview(tableView)
        self.tableView.register(MainCityCell.self, forCellReuseIdentifier: identifire)
    }
    
    
    @objc private func getNewWeather() {
        //self.weathers.removeAll()
       


        for place in self.places {
          //  print("City = \(place.name), coord: \(place.coordinates)")
            self.CityWeatherLoad(coordinates: place.coordinates, days: "7")
            print("self.weathers.count = \(self.weathers.count)")
            print("self.places.count = \(self.places.count)")
          //  print("Погода №2 \(self.weathers.count-1)")

        }
        
        tableView.refreshControl?.endRefreshing()
    }

    
    @objc private func addNewCity() {
        present(self.cityAddVC, animated: true, completion: nil)
    }
    
}



extension MainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if self.places.count > indexPath.section && self.weathers.count > indexPath.section {
            cityWeatherVC.place = self.places[indexPath.section]
            cityWeatherVC.weather = self.weathers[indexPath.section]
            navigationController?.pushViewController(self.cityWeatherVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if self.places.count >= indexPath.section && self.weathers.count >= indexPath.section {
                self.places.remove(at: indexPath.section)
                self.weathers.remove(at: indexPath.section)
            }
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
        cell.objectNameLabel.text = self.places[indexPath.section].name
        cell.objectDescriptionLabel.text = self.places[indexPath.section].title
        if weathers.count > indexPath.section {
            cell.temperatureLabel.text = String(self.weathers[indexPath.section].temp) + "°"
            cell.weatherIconImageView.image = self.weathers[indexPath.section].weatherImage
        }
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

extension Double {
    var scaled: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return screenWidth * CGFloat(self) / 375.0
    }
}

//extension CLPlacemark {
//    var formattedAddress: String? {
//        guard let postalAddress = postalAddress else {
//            return nil
//        }
//        let formatter = CNPostalAddressFormatter()
//        print(
//            postalAddress.city,
//            postalAddress.country,
//            postalAddress.subLocality,
//            postalAddress.subAdministrativeArea,
//            postalAddress.state)
//        return formatter.string(from: postalAddress)
//    }

//
//func showEnterError() {
//    let alert = UIAlertController(title: "Error!", message: "Введены неверные пользовательские данные", preferredStyle: .alert)
//    let action = UIAlertAction(title: "OK", style: .default)
//    alert.addAction(action)
//
//    present(alert, animated: true)
//}

//func addDoneButtonOnKeyboard() {
//       let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 50.0))
//       doneToolbar.barStyle = .default
//
//       let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//       let done: UIBarButtonItem = UIBarButtonItem(title: "Done".localized,
//                                                   style: .done,
//                                                   target: self,
//                                                   action: #selector(self.hideKeyboard))
//       done.tintColor = .electricBlue
//
//       let items = [flexSpace, done]
//       doneToolbar.items = items
//       doneToolbar.sizeToFit()
//
//       self.inputAccessoryView = doneToolbar
//   }
