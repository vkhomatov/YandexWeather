//
//  WeatherService.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 01.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON



class WeatherService {
    
    private let locationManager = LocationManager()

    /// основной путь для запроса к серверу
    private let baseUrl = "https://api.weather.yandex.ru/v2/forecast?"
    
    /// cочетания языка и страны, для которых будут возвращены данные погодных формулировок.
    private let lang = "ru_RU"
    
    /// для каждого из дней ответ будет содержать прогноз погоды по часам
    private let hours = "false"
    
    /// расширенная информация об осадках
    private let extra = "false"
    
    /// настройка сессии
    static let session: Alamofire.Session = {
        
        let configuration = URLSessionConfiguration.default
        var defaultHeaders = HTTPHeaders.default
        
        /// заколовок запроса  =  ключ пользователя API Яндекс погоды, ключ нужно заменить на свой
        defaultHeaders["X-Yandex-API-Key"] = "bf66761c-5cf9-4ade-8a31-a4f617ef280e"
        
        configuration.headers = defaultHeaders
        let session = Alamofire.Session(configuration: configuration)
        return session
    }()
    
    
    
    
    func loadWeatherData(coordinate: CLLocationCoordinate2D, days: String, completion: ((Swift.Result<CityWeather, Error>) -> Void)? = nil) {
            
            let parameters: Parameters = [
                
                "lon": coordinate.longitude,
                
                "lat": coordinate.latitude,
                
                "lang": self.lang,
                
                "limit": days,
                
                "hours": self.hours,
                
                "extra": self.extra
                
            ]
            
            
            WeatherService.session.request(self.baseUrl, method: .get, parameters: parameters).responseJSON { repsonse in
                
                switch repsonse.result {
                    
                case let .success(data):
                    print(data)
                    
                    let json = JSON(data)
                    let weather = CityWeather(from: json)
                    completion?(.success(weather))
                    
                    print("\nWeatherService.session.request: данные загружены")
                    
                case let .failure(error):
                    print("\nWeatherService.session.request: ошибка при загрузке погодных данных - \(error)")
                    
                }
                
            }
        }
        

}
