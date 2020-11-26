//
//  CityWeather.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 02.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import SwiftyJSON
import SVGKit


class CityWeather : Equatable {
    
    static func == (lhs: CityWeather, rhs: CityWeather) -> Bool {
        return lhs.temp == rhs.temp
    }
    
    /// Объект info
    var url: String = ""

    /// Объект fact
    var temp: Int = 0
    var feels_like: Int = 0
    
    var icon: String = ""
    var condition: String = ""
    
    var humidity: Int = 0
    var season: String = ""
    
    var weatherImage = UIImage()

    /// Объект forecasts
    var forecasts : [Forecast] = []
    

    convenience init(from json: JSON) {
        self.init()
        
        self.url = json["info"]["url"].stringValue
        self.temp = json["fact"]["temp"].intValue
        self.temp = json["fact"]["feels_like"].intValue
        self.icon = "https://yastatic.net/weather/i/icons/blueye/color/svg/" + json["fact"]["icon"].stringValue + ".svg"
        self.condition = json["fact"]["condition"].stringValue
        self.humidity = json["fact"]["humidity"].intValue
        self.season = json["fact"]["season"].stringValue
        let forecastsJSON = json["forecasts"].arrayValue
        self.forecasts = forecastsJSON.map { Forecast(from: $0) }        
        
    }
    
}

/// Объект forecast

class Forecast : Equatable {
    
    static func == (lhs: Forecast, rhs: Forecast) -> Bool {
        return lhs.date == rhs.date
    }
    
    var date: String = ""
    var sunrise: String = ""
    var sunset: String = ""
    
    var temp_min: Int = 0
    var temp_max: Int = 0
    var feels_like: Int = 0
    
    
    var icon: String = ""
    var condition: Int = 0
    var wind_speed: Int = 0
    var humidity: Int = 0
    var weatherImage = UIImage()
    
    
    convenience init(from json: JSON) {
        self.init()
        
        self.date = json["date"].stringValue
        self.sunrise = json["sunrise"].stringValue
        self.sunset = json["sunset"].stringValue
        self.temp_min = json["parts"]["day"]["temp_min"].intValue
        self.temp_max = json["parts"]["day"]["temp_max"].intValue
        self.feels_like = json["parts"]["day"]["feels_like"].intValue
        self.icon = "https://yastatic.net/weather/i/icons/blueye/color/svg/" + json["parts"]["day"]["icon"].stringValue + ".svg"
        self.condition = json["parts"]["day"]["condition"].intValue
        self.wind_speed = json["parts"]["day"]["wind_speed"].intValue
        self.humidity = json["parts"]["day"]["humidity"].intValue
        
        
    }

}
