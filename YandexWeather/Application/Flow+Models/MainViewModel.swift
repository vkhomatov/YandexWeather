//
//  MainViewModel.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 27.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit
import MapKit
import SVGKit


class MainViewModel {
    
    var forecastDays : String
    var udService = UDService()
    
    let locationManager = LocationManager()
    let cityAddVC = CityAddViewController()
    let cityWeatherVC = CityWeatherViewController()
    
    let weatherService = WeatherService()
    let currentLocation = CLLocation()
    var weatherImages = [String : UIImage?]()
    
    var updateTableView: (() -> Void)?
    var updateVCTitle: (() -> Void)?
    
    var places = [UserPlace]()  {
        didSet {
            //   DispatchQueue.main.async {
            //    if self.places.count > 0 {
            //  if self.places[self.places.count-1].weather.forecasts.count != 0 {
            if let callback = self.updateTableView {
                callback()
            }
            
            DispatchQueue.global().async {
                self.udService.saveToUd(places: self.places)
                print("\(#function) - udService.saveToUd.count = \(self.places.count)")
                
            }
        }
    }
    
    
    
    init(daysCount: String) {
        self.forecastDays = daysCount
    }
    
    // определяем текущее местоположение и погоду для него
    func getCurrentLocation() {
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
                        self.cityWeatherLoad(place: place, days: self.forecastDays)
                    }
                    
                } else {
                    print("locationManager.getPlace: объект не найден")
                }
            }
        }
    }
    
    // добавляем свои места с прогнозами погоды и загружаем погоду для них
    func addWeather() {
        DispatchQueue.global().async {
            self.cityAddVC.addNewUserPlace = { [weak self] in
                guard let self = self else { return }
                let newPlace = self.cityAddVC.place
                if !self.places.contains(newPlace) {
                    self.places.append(newPlace)
                    self.cityWeatherLoad(place: newPlace, days: self.forecastDays)
                    print("userPlaces.append: объект \(String(describing: newPlace.name) ) был УСПЕШНО добавлен")
                } else {
                    print("userPlaces.append: объект \(String(describing: newPlace.name) ) был добавлен ранее")
                }
            }
        }
    }
    
    
    // загрузка с сервера и кеширование картинок с погодой в словать
    func loadImages(icon: String, weather: CityWeather?, forecast: Forecast?) {
        
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
    
    // функция загрузки погоды для конкретного места
    func cityWeatherLoad(place: UserPlace, days: String) {
        
        //  self.title = "Загрузка данных ..."
        
        DispatchQueue.main.async {
            if let callback = self.updateVCTitle {
                callback()
            }
            
        }
        
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
                //  self.title = "Моя погода [нет данных]"
            }
        }
    }
    
}

extension Double {
    var scaled: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return screenWidth * CGFloat(self) / 375.0
    }
}
