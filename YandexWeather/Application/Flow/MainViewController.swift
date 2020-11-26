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


struct UserPlace: Equatable {
    
    static func == (lhs: UserPlace, rhs: UserPlace) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name  = String()
    var title = String()
    var coordinates = CLLocationCoordinate2D()
    var time = String()
    var weather = CityWeather()
    
}


class MainViewController: UIViewController {
    
    private var locationManager = LocationManager()
    private let cityAddVC = CityAddViewController()
    private let cityWeatherVC = CityWeatherViewController()
    
    var sendDataTocityWeatherVC: (() -> Void)?
    
    private var tableView = UITableView()
    private let weatherService = WeatherService()
    private let identifire = "cityCell"
    private var currentLocation = CLLocation()
    private var refreshControl = UIRefreshControl()
    private var weatherImages = [String : UIImage?]()
    
    var places = [UserPlace]()  {
        didSet {
            DispatchQueue.main.async {
                if self.places[self.places.count-1].weather.forecasts.count != 0 {
                    self.tableView.reloadData()
                    self.title = "Моя погода"
                }
            }
        }
    }
    
    
    fileprivate func getCurrentLocation() {
        self.locationManager.getNewLocation = { [weak self] in
            guard let self = self else { return }
            
            self.locationManager.getPlace(for: self.locationManager.userLocation) { placeMark in
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
                        
                        self.CityWeatherLoad(place: place, days: "7")
                        //self.tableView.reloadData()
                    }
                    
                } else {
                    print("locationManager.getPlace: объект не найден")
                }
            }
            self.locationManager.stopUpdatingLocation()
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
        
        locationManager.requestLocation()
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
                self.CityWeatherLoad(place: newPlace, days: "7")
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
    
    
    // загрузка с сервера и кеширование картинок с погодой в словать
    private func loadImages(icon: String, weather: CityWeather?, forecast: Forecast?) {
        
        if self.weatherImages[icon] == nil {
            // скачиваем картинку погоды
            if let url = URL(string: icon) {
                let data = try? Data(contentsOf: url)
                let anSVGImage: SVGKImage = SVGKImage(data: data)
                if (weather != nil) {
                    weather?.weatherImage = anSVGImage.uiImage
                } else if (forecast != nil) {
                    forecast?.weatherImage = anSVGImage.uiImage
                }
                self.weatherImages.updateValue(weather?.weatherImage, forKey: icon)
            }
        } else {
            if let image = self.weatherImages[icon] {
                if let image = image {
                    if (weather != nil) {
                        weather?.weatherImage = image
                    } else if (forecast != nil) {
                        forecast?.weatherImage = image
                    }
                }
            }
        }
        
    }
    
    func CityWeatherLoad(place: UserPlace, days: String) {
        
        self.title = "Загрузка данных ..."
        
        self.weatherService.loadWeatherData(coordinate: place.coordinates, days: days) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(weather):
                
                self.loadImages(icon: weather.icon, weather: weather, forecast: nil)
                
                for forecast in weather.forecasts {
                    self.loadImages(icon: weather.icon, weather: nil, forecast: forecast)
                }
                
                
                if let num = self.places.firstIndex(of: place) {
                    self.places[num].weather = weather
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
        
        for place in self.places {
            self.CityWeatherLoad(place: place, days: "7")
        }
        
        tableView.refreshControl?.endRefreshing()
    }
    
    
    @objc private func addNewCity() {
        present(self.cityAddVC, animated: true, completion: nil)
    }
    
}



extension MainViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.places.count > indexPath.section  {
            cityWeatherVC.place = self.places[indexPath.section]
            navigationController?.pushViewController(self.cityWeatherVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if self.places.count >= indexPath.section {
                self.places.remove(at: indexPath.section)
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
        if self.places.count > indexPath.section {
            cell.objectNameLabel.text = self.places[indexPath.section].name
            cell.objectDescriptionLabel.text = self.places[indexPath.section].title
            cell.temperatureLabel.text = String(self.places[indexPath.section].weather.temp) + "°"
            cell.weatherIconImageView.image = self.places[indexPath.section].weather.weatherImage
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
