//
//  UserPlace.swift
//  YandexWeather
//
//  Created by Vitaly Khomatov on 27.11.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import CoreLocation

struct UserPlace: Equatable, Codable {
    
    static func == (lhs: UserPlace, rhs: UserPlace) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name  = String()
    var title = String()
    var latitude = Double()
    var longitude = Double()
    
   // var coordinates = CLLocationCoordinate2D()
 //   var time = String()
    var weather = CityWeather()
    
    enum CodingKeys: String, CodingKey {
        case name, title, latitude, longitude
    }
    
    init(name: String, title: String, latitude: Double, longitude: Double) {
        self.name = name
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init() {
        
    }
    
    
    
//    init(place: UDPlace) {
//        self.name = place.name
//        self.title = place.title
//        self.latitude = place.latitude
//        self.longitude = place.longitude
//    }
    
    
}

//struct Coordinate: Codable {
//    var latitude: Double
//    var longitude: Double
//    
//    init(coord: CLLocationCoordinate2D) {
//        self.latitude = coord.latitude
//        self.longitude = coord.longitude
//    }
//}

//struct UDPlace: Equatable, Codable {
//    
//    static func == (lhs: UDPlace, rhs: UDPlace) -> Bool {
//        return lhs.name == rhs.name
//    }
//    
//    var name: String
//    var title: String
//    var latitude: Double
//    var longitude: Double
//    
//    init(place: UserPlace) {
//        self.name = place.name
//        self.title = place.title
//        self.latitude = place.latitude
//        self.longitude = place.longitude
//    }
//    
//}

